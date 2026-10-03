// VHDAutoClickEngine.swift
// Auto click on multiple points with intervals
import UIKit
import Foundation

final class VHDAutoClickEngine {
    static let shared = VHDAutoClickEngine()

    struct ClickPoint: Codable {
        let x: CGFloat
        let y: CGFloat
        let intervalMs: Double
    }

    private(set) var isRunning = false
    private var points: [ClickPoint] = []
    private var timers: [Timer] = []
    private var pointIndex = 0

    private let storageKey = "VHD_AC_ClickPoints"

    func loadPoints() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let arr = try? JSONDecoder().decode([ClickPoint].self, from: data) {
            points = arr
        }
    }

    func savePoints() {
        if let data = try? JSONEncoder().encode(points) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    func addPoint(x: CGFloat, y: CGFloat, intervalMs: Double = 1000) {
        let p = ClickPoint(x: x, y: y, intervalMs: intervalMs)
        points.append(p)
        savePoints()
    }

    func clearPoints() {
        points.removeAll()
        savePoints()
    }

    func currentCount() -> Int { points.count }

    func start() {
        stop()
        loadPoints()
        guard !points.isEmpty else {
            print("[VHD-Click] No points configured")
            return
        }
        isRunning = true
        for p in points {
            let t = Timer.scheduledTimer(withTimeInterval: p.intervalMs / 1000.0, repeats: true) { [weak self] _ in
                self?.performClick(at: p)
            }
            timers.append(t)
        }
        print("[VHD-Click] Started with \(points.count) points")
    }

    func stop() {
        for t in timers { t.invalidate() }
        timers.removeAll()
        isRunning = false
        print("[VHD-Click] Stopped")
    }

    private func performClick(at point: ClickPoint) {
        // Note: in standalone app, we cannot synthesize touches inside TikTok.
        // We provide a manual helper: a notification sound + visual indicator
        // so user knows when to tap.
        AudioServicesPlaySystemSound(1057)  // tock sound

        // We post a notification the floating panel listens to,
        // so it shows "Tap now!" at the recorded position
        NotificationCenter.default.post(
            name: .vhdShouldTap,
            object: nil,
            userInfo: ["x": point.x, "y": point.y]
        )
        print("[VHD-Click] Tap at (\(point.x), \(point.y))")
    }
}

import AudioToolbox
extension Notification.Name {
    static let vhdShouldTap = Notification.Name("VHD_ShouldTap")
}
