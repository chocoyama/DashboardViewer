import Foundation
import WebKit

public struct DashboardNavigationDecider: WebPage.NavigationDeciding {
    // 設定の変更を開いているページにもすぐ効かせるため、判定のたびに最新の登録を読む
    let currentDashboard: @MainActor () -> Dashboard?
    let reopenInDashboard: @MainActor (URL) -> Void
    let openInDefaultBrowser: @MainActor (URL) -> Void

    public init(currentDashboard: @escaping @MainActor () -> Dashboard?,
                reopenInDashboard: @escaping @MainActor (URL) -> Void,
                openInDefaultBrowser: @escaping @MainActor (URL) -> Void) {
        self.currentDashboard = currentDashboard
        self.reopenInDashboard = reopenInDashboard
        self.openInDefaultBrowser = openInDefaultBrowser
    }

    public func decidePolicy(for action: WebPage.NavigationAction,
                             preferences: inout WebPage.NavigationPreferences) async -> WKNavigationActionPolicy {
        guard let destination = action.request.url, let dashboard = currentDashboard() else { return .cancel }
        switch navigationRoute(to: destination, in: action.frame,
                               dashboardURL: dashboard.url, scope: dashboard.inAppNavigationScope) {
        case .stayInDashboard:
            return .allow
        case .reopenInDashboard:
            reopenInDashboard(destination)
            return .cancel
        case .openInDefaultBrowser:
            openInDefaultBrowser(destination)
            return .cancel
        }
    }
}

private extension WebPage.NavigationAction {
    var frame: NavigationFrame {
        guard let target else { return .newWindow }
        return target.isMainFrame ? .mainFrame : .subframe
    }
}
