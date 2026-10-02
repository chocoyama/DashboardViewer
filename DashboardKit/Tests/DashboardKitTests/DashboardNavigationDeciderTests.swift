import Foundation
import Testing
import WebKit
import DashboardKit

/// 実物の WebPage にページを読み込ませ、リンクを踏んだときの振る舞いを確かめる。
@MainActor
struct DashboardNavigationDeciderTests {
    let dashboardURL = URL(string: "https://dashboard.test/home")!
    let html = """
    <a id="anchor" href="#section">anchor</a>
    <a id="other" href="https://dashboard.test/other">other</a>
    <a id="blank" href="https://dashboard.test/blank" target="_blank">blank</a>
    <p id="section">section</p>
    """

    @Test(arguments: [
        ("other", "https://dashboard.test/other"),
        ("blank", "https://dashboard.test/blank"),
    ])
    func 別ページへのリンクはブラウザへ回してダッシュボードに留まる(linkID: String, expected: String) async throws {
        let (page, opened) = try await loadedPage()

        _ = try await page.callJavaScript("document.getElementById(id).click()", arguments: ["id": linkID])
        try await waitUntil { !opened.urls.isEmpty }

        #expect(opened.urls == [URL(string: expected)!])
        #expect(page.url == dashboardURL)
    }

    @Test func アンカーリンクはダッシュボード内でスクロールする() async throws {
        let (page, opened) = try await loadedPage()

        _ = try await page.callJavaScript("document.getElementById('anchor').click()")
        try await waitUntil { page.url?.fragment == "section" }

        #expect(opened.urls.isEmpty)
    }

    private func loadedPage() async throws -> (WebPage, OpenedURLs) {
        let opened = OpenedURLs()
        let decider = DashboardNavigationDecider(dashboardURL: dashboardURL) { opened.urls.append($0) }
        let page = WebPage(navigationDecider: decider)
        // load(html:baseURL:) は decidePolicy を通らないため、ダッシュボードの URL として擬似応答を返す
        let response = HTTPURLResponse(url: dashboardURL, statusCode: 200, httpVersion: nil,
                                       headerFields: ["Content-Type": "text/html"])!
        for try await _ in page.load(simulatedRequest: URLRequest(url: dashboardURL), response: response,
                                     responseData: Data(html.utf8)) {}
        return (page, opened)
    }

    private func waitUntil(_ condition: () -> Bool) async throws {
        for _ in 0..<100 where !condition() {
            try await Task.sleep(for: .milliseconds(20))
        }
        try #require(condition())
    }
}

@MainActor
private final class OpenedURLs {
    var urls: [URL] = []
}
