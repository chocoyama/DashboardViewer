import Combine
import Foundation

extension NotificationCenter {
    func postDashboardLoginDidFinish(_ request: DashboardLoginRequest) {
        post(name: .dashboardLoginDidFinish, object: request)
    }

    var finishedDashboardLogins: some Combine.Publisher<DashboardLoginRequest, Never> {
        publisher(for: .dashboardLoginDidFinish).compactMap { $0.object as? DashboardLoginRequest }
    }
}

private extension Notification.Name {
    static let dashboardLoginDidFinish = Notification.Name("dashboardLoginDidFinish")
}
