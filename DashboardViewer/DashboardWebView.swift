import DashboardKit
import SwiftUI
import WebKit

struct DashboardWebView: View {
    let dashboard: Dashboard
    let page: WebPage

    private static let autoReloadInterval: Duration = .seconds(10 * 60)

    var body: some View {
        WebView(page)
            .task { page.load(dashboard.url) }
            .task { await reloadPeriodically() }
    }

    private func reloadPeriodically() async {
        while (try? await Task.sleep(for: Self.autoReloadInterval)) != nil {
            page.reload()
        }
    }
}
