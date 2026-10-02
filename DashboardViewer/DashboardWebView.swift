import AppKit
import DashboardKit
import SwiftUI
import WebKit

struct DashboardWebView: View {
    let dashboard: Dashboard

    @State private var page: WebPage

    init(dashboard: Dashboard) {
        self.dashboard = dashboard
        let decider = DashboardNavigationDecider(dashboardURL: dashboard.url) { NSWorkspace.shared.open($0) }
        _page = State(initialValue: WebPage(navigationDecider: decider))
    }

    var body: some View {
        WebView(page)
            .task { page.load(dashboard.url) }
    }
}
