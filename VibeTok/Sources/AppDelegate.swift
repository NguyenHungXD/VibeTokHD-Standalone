// AppDelegate.swift - VibeTokHD Standalone (no jailbreak needed)
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var floatingPanel: VHDStandalonePanel?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // Normal app window
        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        let root = VHDMainViewController()
        mainWindow.rootViewController = root
        mainWindow.makeKeyAndVisible()
        self.window = mainWindow

        // Build a separate UIWindow for floating panel (always on top)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.installFloatingPanel()
        }

        print("[VHD] VibeTokHD Standalone launched")
        return true
    }

    private func installFloatingPanel() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let panelWindow = VHDStandalonePanel(windowScene: scene)
        panelWindow.makeKeyAndVisible()
        self.floatingPanel = panelWindow
        print("[VHD] Floating panel installed")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        VHDAutoSwipeEngine.shared.stop()
        VHDAutoClickEngine.shared.stop()
    }
}
