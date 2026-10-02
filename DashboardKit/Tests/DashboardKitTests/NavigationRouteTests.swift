import Foundation
import Testing
import DashboardKit

struct NavigationRouteTests {
    let dashboard = URL(string: "https://example.com/dashboard?team=a")!

    @Test func 指定URLはダッシュボード内で表示する() {
        #expect(navigationRoute(to: dashboard, in: .mainFrame, dashboardURL: dashboard) == .stayInDashboard)
    }

    @Test func フラグメントだけ違うURLはダッシュボード内で表示する() {
        let url = URL(string: "https://example.com/dashboard?team=a#chart")!
        #expect(navigationRoute(to: url, in: .mainFrame, dashboardURL: dashboard) == .stayInDashboard)
    }

    @Test(arguments: [
        "https://example.com/dashboard?team=b",
        "https://example.com/other",
        "https://other.example.com/dashboard?team=a",
        "http://example.com/dashboard?team=a",
    ])
    func 指定URL以外はブラウザで開く(destination: String) {
        let url = URL(string: destination)!
        #expect(navigationRoute(to: url, in: .mainFrame, dashboardURL: dashboard) == .openInDefaultBrowser)
    }

    @Test func iframeの読み込みはダッシュボード内で行う() {
        let url = URL(string: "https://charts.example.net/embed")!
        #expect(navigationRoute(to: url, in: .subframe, dashboardURL: dashboard) == .stayInDashboard)
    }

    @Test func 新規ウインドウはURLが同じでもブラウザで開く() {
        #expect(navigationRoute(to: dashboard, in: .newWindow, dashboardURL: dashboard) == .openInDefaultBrowser)
    }
}
