import Combine
import DashboardKit
import Foundation

extension NotificationCenter {
    func postDashboardLoginDidFinish(id: Dashboard.ID) {
        post(name: .dashboardLoginDidFinish, object: id)
    }

    var loggedInDashboardIDs: some Combine.Publisher<Dashboard.ID, Never> {
        publisher(for: .dashboardLoginDidFinish).compactMap { $0.object as? Dashboard.ID }
    }
}

private extension Notification.Name {
    static let dashboardLoginDidFinish = Notification.Name("dashboardLoginDidFinish")
}
