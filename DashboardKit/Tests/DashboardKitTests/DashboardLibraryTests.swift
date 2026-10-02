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
}
