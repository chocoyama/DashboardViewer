import DashboardKit
import SwiftUI
import WebKit

struct DashboardCommands: Commands {
    @FocusedValue(\.selectedDashboard) private var dashboard
    @FocusedValue(\.selectedDashboardPage) private var page
    @Environment(\.openWindow) private var openWindow

    var body: some Commands {
        CommandMenu("ダッシュボード") {
            Button("再読み込み") { page?.reload() }
                .keyboardShortcut("r")
                .disabled(page == nil)
            Button("ログインし直す…") {
                if let dashboard { openWindow(value: dashboard) }
            }
            .disabled(dashboard == nil)
        }
    }
}
