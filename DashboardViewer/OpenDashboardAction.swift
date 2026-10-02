import DashboardKit
import SwiftUI

/// ダッシュボードを開いた後は一覧が不要になるため、一緒に閉じる。
struct OpenDashboardAction {
    let openWindow: OpenWindowAction
    let dismissWindow: DismissWindowAction

    func callAsFunction(_ id: Dashboard.ID) {
        openWindow(value: id)
        dismissWindow(id: DashboardLibraryWindow.id)
    }
}
