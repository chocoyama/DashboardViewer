import Foundation
import Observation

/// 登録済みダッシュボードの一覧。変更のたびに UserDefaults へ保存する。
@MainActor
@Observable
public final class DashboardLibrary {
    public private(set) var dashboards: [Dashboard]

    @ObservationIgnored private let defaults: UserDefaults
    private static let defaultsKey = "dashboards"

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.dashboards = defaults.data(forKey: Self.defaultsKey)
            .flatMap { try? JSONDecoder().decode([Dashboard].self, from: $0) } ?? []
    }

    public func dashboard(id: Dashboard.ID) -> Dashboard? {
        dashboards.first { $0.id == id }
    }

    public func add(_ dashboard: Dashboard) {
        dashboards.append(dashboard)
        save()
    }

    public func remove(id: Dashboard.ID) {
        dashboards.removeAll { $0.id == id }
        save()
    }

    private func save() {
        // [Dashboard] は String・URL・UUID だけで構成されるため、エンコードは失敗しない
        defaults.set(try! JSONEncoder().encode(dashboards), forKey: Self.defaultsKey)
    }
}
