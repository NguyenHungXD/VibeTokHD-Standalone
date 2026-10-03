// VHDStandalonePanel.swift
// Floating control panel - a separate UIWindow that floats over TikTok
import UIKit
import AudioToolbox

final class VHDStandalonePanel: UIWindow {
    private let mainButton = UIButton(type: .system)
    private let panelView = UIView()
    private let statusLabel = UILabel()
    private let dirControl = UISegmentedControl(items: ["↑", "←", "↓", "→"])
    private let minField = UITextField()
    private let maxField = UITextField()
    private let loopField = UITextField()
    private let swipeBtn = UIButton(type: .system)
    private let clickBtn = UIButton(type: .system)
    private let addPointBtn = UIButton(type: .system)
    private let stopOnEndSwitch = UISwitch()
    private var panelTouchOffset: CGPoint = .zero

    override init(windowScene: UIWindowScene) {
        let screen = windowScene.screen.bounds
        super.init(windowScene: windowScene)
        self.frame = CGRect(x: screen.width - 60, y: 100, width: 50, height: 50)
        self.windowLevel = .alert + 100
        self.backgroundColor = .clear
        buildUI()
        observe()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) not supported") }

    private func buildUI() {
        mainButton.frame = bounds
        mainButton.layer.cornerRadius = 25
        mainButton.backgroundColor = .systemPink
        mainButton.setTitle("⚡", for: .normal)
        mainButton.setTitleColor(.white, for: .normal)
        mainButton.titleLabel?.font = .systemFont(ofSize: 24)
        mainButton.addTarget(self, action: #selector(togglePanel), for: .touchUpInside)
        addSubview(mainButton)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        mainButton.addGestureRecognizer(pan)

        let screen = UIScreen.main.bounds
        panelView.frame = CGRect(x: 20, y: screen.height - 360, width: screen.width - 40, height: 320)
        panelView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        panelView.layer.cornerRadius = 14
        panelView.isHidden = true
        addSubview(panelView)
        buildPanelContent()
    }

    private func buildPanelContent() {
        let p = panelView
        var y: CGFloat = 12

        let title = UILabel()
        title.text = "VibeTokHD Auto Controller"
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 14)
        title.frame = CGRect(x: 12, y: y, width: p.bounds.width - 24, height: 20)
        p.addSubview(title)
        y += 30

        statusLabel.text = "Sẵn sàng"
        statusLabel.textColor = .systemGreen
        statusLabel.font = .systemFont(ofSize: 12)
        statusLabel.frame = CGRect(x: 12, y: y, width: p.bounds.width - 24, height: 18)
        p.addSubview(statusLabel)
        y += 24

        dirControl.selectedSegmentIndex = 0
        dirControl.frame = CGRect(x: 12, y: y, width: 220, height: 28)
        dirControl.addTarget(self, action: #selector(directionChanged), for: .valueChanged)
        p.addSubview(dirControl)
        y += 36

        // Min/Max/Loop fields
        let minL = makeLabel("Min ms", y: y)
        minField.text = "800"; minField.frame = CGRect(x: 12, y: y + 22, width: 80, height: 28)
        let maxL = makeLabel("Max ms", y: y, x: 110)
        maxField.text = "1500"; maxField.frame = CGRect(x: 110, y: y + 22, width: 80, height: 28)
        let loopL = makeLabel("Loop (0=∞)", y: y, x: 208)
        loopField.text = "0"; loopField.frame = CGRect(x: 208, y: y + 22, width: 80, height: 28)
        [minL, maxL, loopL].forEach { p.addSubview($0) }
        p.addSubview(minField); p.addSubview(maxField); p.addSubview(loopField)
        styleField(minField); styleField(maxField); styleField(loopField)
        y += 60

        // Stop-when-feed-ends
        let stopL = UILabel()
        stopL.text = "Dừng khi hết video"
        stopL.textColor = .white
        stopL.font = .systemFont(ofSize: 13)
        stopL.frame = CGRect(x: 12, y: y, width: 200, height: 20)
        p.addSubview(stopL)
        stopOnEndSwitch.isOn = true
        stopOnEndSwitch.frame.origin = CGPoint(x: p.bounds.width - 64, y: y - 4)
        p.addSubview(stopOnEndSwitch)
        y += 28

        // Swipe / Click buttons
        swipeBtn.frame = CGRect(x: 12, y: y, width: 130, height: 36)
        styleButton(swipeBtn, "Start Swipe", .systemBlue)
        swipeBtn.addTarget(self, action: #selector(toggleSwipe), for: .touchUpInside)
        p.addSubview(swipeBtn)

        clickBtn.frame = CGRect(x: 150, y: y, width: 130, height: 36)
        styleButton(clickBtn, "Start Click", .systemOrange)
        clickBtn.addTarget(self, action: #selector(toggleClick), for: .touchUpInside)
        p.addSubview(clickBtn)
        y += 46

        // Add click point
        addPointBtn.frame = CGRect(x: 12, y: y, width: p.bounds.width - 24, height: 32)
        styleButton(addPointBtn, "+ Add Click Point", .systemPurple)
        addPointBtn.addTarget(self, action: #selector(addClickPoint), for: .touchUpInside)
        p.addSubview(addPointBtn)
        y += 38

        // Close
        let close = UIButton(type: .system)
        close.frame = CGRect(x: 12, y: y, width: p.bounds.width - 24, height: 28)
        close.setTitle("✕ Close Panel", for: .normal)
        close.setTitleColor(.lightGray, for: .normal)
        close.titleLabel?.font = .systemFont(ofSize: 13)
        close.addTarget(self, action: #selector(togglePanel), for: .touchUpInside)
        p.addSubview(close)

        // Open TikTok button
        let open = UIButton(type: .system)
        open.frame = CGRect(x: 12, y: y + 32, width: p.bounds.width - 24, height: 28)
        open.setTitle("📱 Mở TikTok", for: .normal)
        open.setTitleColor(.cyan, for: .normal)
        open.titleLabel?.font = .systemFont(ofSize: 13)
        open.addTarget(self, action: #selector(openTikTok), for: .touchUpInside)
        p.addSubview(open)
    }

    private func makeLabel(_ text: String, y: CGFloat, x: CGFloat = 12) -> UILabel {
        let l = UILabel()
        l.text = text
        l.textColor = .white
        l.font = .systemFont(ofSize: 11)
        l.frame = CGRect(x: x, y: y, width: 80, height: 20)
        return l
    }

    private func styleField(_ tf: UITextField) {
        tf.borderStyle = .roundedRect
        tf.textColor = .white
        tf.keyboardType = .numberPad
    }

    private func styleButton(_ b: UIButton, _ title: String, _ color: UIColor) {
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 8
        b.backgroundColor = color
    }

    private func observe() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(feedExhausted),
            name: VHDAutoSwipeEngine.feedExhaustedNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(shouldTap(_:)),
            name: .vhdShouldTap, object: nil)
    }

    // MARK: - Actions
    @objc private func togglePanel() {
        panelView.isHidden.toggle()
        if !panelView.isHidden { updateStatus() }
    }

    @objc private func directionChanged() {
        VHDAutoSwipeEngine.shared.direction = VHDAutoSwipeEngine.SwipeDirection(rawValue: dirControl.selectedSegmentIndex) ?? .up
    }

    @objc private func toggleSwipe() {
        let e = VHDAutoSwipeEngine.shared
        if e.isRunning {
            e.stop()
            styleButton(swipeBtn, "Start Swipe", .systemBlue)
        } else {
            e.direction = VHDAutoSwipeEngine.SwipeDirection(rawValue: dirControl.selectedSegmentIndex) ?? .up
            e.minIntervalMs = Double(minField.text ?? "800") ?? 800
            e.maxIntervalMs = Double(maxField.text ?? "1500") ?? 1500
            e.loopCount = Int(loopField.text ?? "0") ?? 0
            e.stopWhenFeedEnds = stopOnEndSwitch.isOn
            e.start()
            styleButton(swipeBtn, "Stop Swipe", .systemRed)
        }
        updateStatus()
    }

    @objc private func toggleClick() {
        let e = VHDAutoClickEngine.shared
        if e.isRunning {
            e.stop()
            styleButton(clickBtn, "Start Click", .systemOrange)
        } else {
            e.start()
            styleButton(clickBtn, "Stop Click", .systemRed)
        }
        updateStatus()
    }

    @objc private func addClickPoint() {
        styleButton(addPointBtn, "Tap vào vị trí bất kỳ rồi quay lại...", .systemGreen)
        addPointBtn.isEnabled = false
        // Wait for next tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleRecordedTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        // We add it to a transparent overlay
        let overlay = UIView(frame: UIScreen.main.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.001)
        overlay.tag = 99999
        addSubview(overlay)
        overlay.addGestureRecognizer(tap)
    }

    @objc private func handleRecordedTap(_ gr: UITapGestureRecognizer) {
        let pt = gr.location(in: gr.view)
        if let overlay = viewWithTag(99999) {
            overlay.removeFromSuperview()
        }
        VHDAutoClickEngine.shared.addPoint(x: pt.x, y: pt.y, intervalMs: 1000)
        addPointBtn.isEnabled = true
        let count = VHDAutoClickEngine.shared.currentCount()
        styleButton(addPointBtn, "+ Đã thêm (\(Int(pt.x)),\(Int(pt.y))) - Tổng: \(count)", .systemPurple)
    }

    @objc private func openTikTok() {
        let schemes = ["tiktok://", "snssdk1233://", "musically://"]
        for s in schemes {
            if let url = URL(string: s) {
                UIApplication.shared.open(url, options: [:]) { _ in }
                return
            }
        }
    }

    @objc private func feedExhausted() {
        statusLabel.text = "🔥 Hết video rồi!"
        statusLabel.textColor = .systemRed
        styleButton(swipeBtn, "Feed hết", .darkGray)
        swipeBtn.isEnabled = false
        showToast("🔥 Đã xem hết video")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.swipeBtn.isEnabled = true
            self.styleButton(self.swipeBtn, "Start Swipe", .systemBlue)
            self.statusLabel.text = "Sẵn sàng"
            self.statusLabel.textColor = .systemGreen
        }
    }

    @objc private func shouldTap(_ n: Notification) {
        guard let info = n.userInfo,
              let x = info["x"] as? CGFloat,
              let y = info["y"] as? CGFloat else { return }
        showToast("👆 Tap now at (\(Int(x)),\(Int(y)))")
        AudioServicesPlaySystemSound(1057)
    }

    @objc private func handlePan(_ gr: UIPanGestureRecognizer) {
        let t = gr.translation(in: self)
        if gr.state == .began {
            panelTouchOffset = frame.origin
        }
        frame = CGRect(
            x: panelTouchOffset.x + t.x,
            y: panelTouchOffset.y + t.y,
            width: frame.width, height: frame.height)
    }

    private func updateStatus() {
        let s = VHDAutoSwipeEngine.shared.isRunning
        let c = VHDAutoClickEngine.shared.isRunning
        if s && c { statusLabel.text = "Đang swipe + click"; statusLabel.textColor = .systemYellow }
        else if s { statusLabel.text = "Đang swipe..."; statusLabel.textColor = .systemYellow }
        else if c { statusLabel.text = "Đang click..."; statusLabel.textColor = .systemYellow }
        else { statusLabel.text = "Sẵn sàng"; statusLabel.textColor = .systemGreen }
    }

    private func showToast(_ msg: String) {
        let toast = UILabel()
        toast.text = msg
        toast.textAlignment = .center
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        toast.layer.cornerRadius = 8
        toast.clipsToBounds = true
        toast.font = .systemFont(ofSize: 13)
        toast.numberOfLines = 0
        toast.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 50)
        addSubview(toast)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.3, animations: { toast.alpha = 0 }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
}
