import Foundation
import WebKit

public struct DashboardNavigationDecider: WebPage.NavigationDeciding {
    let dashboardURL: URL
    let openInDefaultBrowser: @MainActor (URL) -> Void

    public init(dashboardURL: URL, openInDefaultBrowser: @escaping @MainActor (URL) -> Void) {
        self.dashboardURL = dashboardURL
        self.openInDefaultBrowser = openInDefaultBrowser
    }

    public func decidePolicy(for action: WebPage.NavigationAction,
                             preferences: inout WebPage.NavigationPreferences) async -> WKNavigationActionPolicy {
        guard let destination = action.request.url else { return .cancel }
        switch navigationRoute(to: destination, in: action.frame, dashboardURL: dashboardURL) {
        case .stayInDashboard:
            return .allow
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
