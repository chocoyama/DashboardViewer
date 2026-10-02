import Foundation
import Testing
import DashboardKit

struct DashboardAddressTests {
    @Test func 前後の空白を除いてURLにする() {
        #expect(dashboardURL(from: "  https://example.com/a \n") == URL(string: "https://example.com/a"))
    }

    @Test(arguments: ["", "example.com", "file:///tmp/a.html", "ftp://example.com", "https://"])
    func httpとhttps以外は受け付けない(text: String) {
        #expect(dashboardURL(from: text) == nil)
    }
}
