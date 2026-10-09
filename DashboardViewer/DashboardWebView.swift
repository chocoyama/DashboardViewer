import AppKit
import DashboardKit
import SwiftUI
import WebKit

struct DashboardWebView: View {
    let dashboard: Dashboard
    let page: WebPage

    @State private var isScreenAsleep = false
    @State private var skippedReloadWhileAsleep = false

    private static let autoReloadInterval: Duration = .seconds(10 * 60)
    private static let workspaceNotifications = NSWorkspace.shared.notificationCenter

    var body: some View {
        WebView(page)
            .task { page.load(dashboard.url) }
            .task { await reloadPeriodically() }
            .onReceive(Self.workspaceNotifications.publisher(for: NSWorkspace.screensDidSleepNotification)) { _ in
                isScreenAsleep = true
            }
            .onReceive(Self.workspaceNotifications.publisher(for: NSWorkspace.screensDidWakeNotification)) { _ in
                isScreenAsleep = false
                // 眠っている間に見送った再読み込みを、画面が点いたときに済ませる
                if skippedReloadWhileAsleep {
                    skippedReloadWhileAsleep = false
                    page.reload()
                }
            }
    }

    // 誰も見ていない間はアクセスしない
    private func reloadPeriodically() async {
        while (try? await Task.sleep(for: Self.autoReloadInterval)) != nil {
            if isScreenAsleep {
                skippedReloadWhileAsleep = true
            } else {
                page.reload()
            }
        }
    }
}
