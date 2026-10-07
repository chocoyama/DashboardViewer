import Foundation
import Testing
import DashboardKit

@MainActor
struct DashboardLibraryTests {
    let defaults = UserDefaults(suiteName: "DashboardLibraryTests-\(UUID())")!

    @Test func 追加と削除が次回起動時にも残る() {
        let first = Dashboard(name: "A", url: URL(string: "https://example.com/a")!)
        let second = Dashboard(name: "B", url: URL(string: "https://example.com/b")!)
        let library = DashboardLibrary(defaults: defaults)
        library.add(first)
        library.add(second)
        library.remove(id: first.id)

        #expect(DashboardLibrary(defaults: defaults).dashboards == [second])
    }

    @Test(arguments: [
        (source: 0, destination: 2, expected: ["B", "C", "A"]),
        (source: 2, destination: 0, expected: ["C", "A", "B"]),
        (source: 0, destination: 1, expected: ["B", "A", "C"]),
        (source: 1, destination: 1, expected: ["A", "B", "C"]),
    ])
    func 移動先のダッシュボードがいた位置へ並べ替えて保存する(source: Int, destination: Int, expected: [String]) {
        let library = DashboardLibrary(defaults: defaults)
        for name in ["A", "B", "C"] {
            library.add(Dashboard(name: name, url: URL(string: "https://example.com/\(name)")!))
        }
        library.move(id: library.dashboards[source].id, toPositionOf: library.dashboards[destination].id)

        #expect(DashboardLibrary(defaults: defaults).dashboards.map(\.name) == expected)
    }

    @Test func 設定を変更すると次回起動時にも残る() {
        let library = DashboardLibrary(defaults: defaults)
        var dashboard = Dashboard(name: "A", url: URL(string: "https://app.example.com/a")!)
        library.add(dashboard)
        dashboard.inAppNavigationScope = .domainAndSubdomains("example.com")
        library.update(dashboard)

        #expect(DashboardLibrary(defaults: defaults).dashboards == [dashboard])
    }

    @Test func 設定の導入前に保存した登録は登録ページのみとして読み込む() {
        let json = #"[{"id":"11111111-1111-1111-1111-111111111111","name":"A","url":"https:\/\/example.com\/a"}]"#
        defaults.set(Data(json.utf8), forKey: "dashboards")

        #expect(DashboardLibrary(defaults: defaults).dashboards.map(\.inAppNavigationScope) == [.dashboardPage])
    }
}
