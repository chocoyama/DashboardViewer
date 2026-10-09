import Foundation
import Testing
import DashboardKit

struct NavigationRouteTests {
    let dashboard = URL(string: "https://app.example.com/dashboard?team=a")!

    private func route(to destination: String, in frame: NavigationFrame = .mainFrame,
                       scope: InAppNavigationScope = .dashboardPage) -> NavigationRoute {
        navigationRoute(to: URL(string: destination)!, in: frame, dashboardURL: dashboard, scope: scope)
    }

    @Test(arguments: [
        "https://app.example.com/dashboard?team=a",
        "https://app.example.com/dashboard?team=a#chart",
    ])
    func 登録ページはフラグメントが違ってもダッシュボード内で表示する(destination: String) {
        #expect(route(to: destination) == .stayInDashboard)
    }

    @Test(arguments: [
        "https://app.example.com/dashboard?team=b",
        "https://app.example.com/other",
        "https://other.example.com/dashboard?team=a",
        "http://app.example.com/dashboard?team=a",
    ])
    func 登録ページのみの設定では登録ページ以外をブラウザで開く(destination: String) {
        #expect(route(to: destination) == .openInDefaultBrowser)
    }

    @Test(arguments: [
        ("https://app.example.com/other", NavigationRoute.stayInDashboard),
        ("http://APP.example.com/other", .stayInDashboard),
        ("https://api.example.com/other", .openInDefaultBrowser),
        ("https://example.com/other", .openInDefaultBrowser),
        ("mailto:someone@example.com", .openInDefaultBrowser),
    ])
    func 同じホストの設定ではホストが一致するページだけをダッシュボード内で表示する(destination: String, expected: NavigationRoute) {
        #expect(route(to: destination, scope: .sameHost) == expected)
    }

    @Test(arguments: [
        ("https://example.com/other", NavigationRoute.stayInDashboard),
        ("https://api.example.com/other", .stayInDashboard),
        ("https://deep.api.example.com/other", .stayInDashboard),
        ("https://notexample.com/other", .openInDefaultBrowser),
        ("https://example.com.evil.test/other", .openInDefaultBrowser),
    ])
    func ドメインの設定ではそのドメインとサブドメインをダッシュボード内で表示する(destination: String, expected: NavigationRoute) {
        #expect(route(to: destination, scope: .domainAndSubdomains("example.com")) == expected)
    }

    @Test func リダイレクトなど利用者の操作によらない遷移は範囲外でもダッシュボード内で表示する() {
        let destination = URL(string: "https://login.example.net/sso")!
        #expect(navigationRoute(to: destination, in: .mainFrame, isUserInitiated: false,
                                dashboardURL: dashboard, scope: .dashboardPage) == .stayInDashboard)
    }

    @Test func iframeの読み込みは範囲外でもダッシュボード内で行う() {
        #expect(route(to: "https://charts.example.net/embed", in: .subframe) == .stayInDashboard)
    }

    @Test(arguments: [
        ("https://app.example.com/other", NavigationRoute.reopenInDashboard),
        ("https://charts.example.net/other", .openInDefaultBrowser),
    ])
    func 新規ウインドウは範囲内ならダッシュボードで開き直す(destination: String, expected: NavigationRoute) {
        #expect(route(to: destination, in: .newWindow, scope: .sameHost) == expected)
    }

    @Test(arguments: [
        ("https://app.example.co.jp/x", ["app.example.co.jp", "example.co.jp", "co.jp"]),
        ("https://Example.com/x", ["example.com"]),
        ("http://localhost:8080/x", []),
        ("http://192.168.0.1/x", []),
        ("http://[::1]/x", []),
    ])
    func 選べるドメインはホストから2ラベルまで親をたどりIPと単一ラベルは対象外(url: String, expected: [String]) {
        #expect(selectableDomains(for: URL(string: url)!) == expected)
    }
}
