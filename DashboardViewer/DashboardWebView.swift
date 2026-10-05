import DashboardKit
import SwiftUI
import WebKit

struct DashboardWebView: View {
    let dashboard: Dashboard
    let page: WebPage

    var body: some View {
        WebView(page)
            .task { page.load(dashboard.url) }
    }
}
