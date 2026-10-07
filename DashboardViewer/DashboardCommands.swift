import DashboardKit
import SwiftUI
import WebKit

struct DashboardCommands: Commands {
    @FocusedValue(\.selectedDashboard) private var dashboard
    @FocusedValue(\.selectedDashboardLoginRequest) private var loginRequest
    @FocusedValue(\.selectedDashboardPage) private var page
    @FocusedBinding(\.isAddingDashboard) private var isAddingDashboard
    @Environment(\.openWindow) private var openWindow

    var body: some Commands {
        CommandMenu("ダッシュボード") {
            Button("新しいタブ…") { isAddingDashboard = true }
                .keyboardShortcut("t")
                .disabled(isAddingDashboard == nil)
            Divider()
            Button("再読み込み") { page?.reload() }
                .keyboardShortcut("r")
                .disabled(page == nil)
            Button("戻る") { page?.goBack() }
                .keyboardShortcut("[")
                .disabled(page?.previousItem == nil)
            Button("ダッシュボードに戻る") {
                if let dashboard { page?.load(dashboard.url) }
            }
            .keyboardShortcut("h", modifiers: [.command, .shift])
            .disabled(page == nil || dashboard == nil)
            Divider()
            Button("ログインし直す…") {
                if let loginRequest { openWindow(value: loginRequest) }
            }
            .disabled(loginRequest == nil)
        }
    }
}
