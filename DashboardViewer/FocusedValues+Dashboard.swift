import DashboardKit
import SwiftUI
import WebKit

extension FocusedValues {
    @Entry var selectedDashboard: Dashboard?
    @Entry var selectedDashboardLoginRequest: DashboardLoginRequest?
    @Entry var selectedDashboardPage: WebPage?
    @Entry var isAddingDashboard: Binding<Bool>?
}
