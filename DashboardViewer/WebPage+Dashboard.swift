import AppKit
import DashboardKit
import WebKit

extension WebPage {
    convenience init(dashboard: Dashboard) {
        let decider = DashboardNavigationDecider(dashboardURL: dashboard.url) { NSWorkspace.shared.open($0) }
        self.init(navigationDecider: decider)
    }
}
