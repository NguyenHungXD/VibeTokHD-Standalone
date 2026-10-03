// VHDMainViewController.swift
// Main screen - shows status, info, and tutorial
import UIKit

final class VHDMainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let title = UILabel()
        title.text = "⚡ VibeTokHD"
        title.font = .boldSystemFont(ofSize: 28)
        title.textAlignment = .center
        title.frame = CGRect(x: 0, y: 60, width: view.bounds.width, height: 40)
        view.addSubview(title)

        let subtitle = UILabel()
        subtitle.text = "Auto Swipe & Click cho TikTok"
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = .secondaryLabel
        subtitle.textAlignment = .center
        subtitle.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 20)
        view.addSubview(subtitle)

        let info = UILabel()
        info.text = """
        📱 Cách dùng:

        1. Nhấn nút ⚡ (nổi) để mở panel
        2. Mở TikTok từ Springboard
        3. Bật "Start Swipe" trong panel
        4. Về TikTok và tận hưởng
        5. Swipe sẽ tự dừng khi hết video

        ⚠️ Lưu ý:
        • Chỉ hoạt động khi app này ở foreground
        • Vì không cần jailbreak nên swipe được thực hiện
          thông qua "người dùng tự chạm" được hướng dẫn bởi
          app VibeTokHD
        • iOS không cho phép 1 app chạm vào app khác

        🔧 Hỗ trợ:
        • GitHub: github.com/NguyenHungXD/VibeTokHD
        """
        info.numberOfLines = 0
        info.font = .systemFont(ofSize: 13)
        info.textColor = .label
        info.frame = CGRect(x: 20, y: 140, width: view.bounds.width - 40, height: 500)
        view.addSubview(info)

        let version = UILabel()
        version.text = "v2.0 - Standalone (eSign compatible)"
        version.font = .systemFont(ofSize: 11)
        version.textColor = .tertiaryLabel
        version.textAlignment = .center
        version.frame = CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 20)
        view.addSubview(version)
    }
}
