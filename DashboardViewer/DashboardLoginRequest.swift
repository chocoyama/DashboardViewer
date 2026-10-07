import DashboardKit
import Foundation

/// ログイン完了後の行き先を決めるため、ログイン画面をどこから開いたかを持たせる。
struct DashboardLoginRequest: Codable, Hashable {
    let dashboard: Dashboard
    let origin: Origin

    enum Origin: Codable, Hashable {
        case library
        case dashboardWindow(UUID)
    }
}
