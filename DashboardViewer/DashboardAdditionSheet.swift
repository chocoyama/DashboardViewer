import DashboardKit
import SwiftUI

struct DashboardAdditionSheet: View {
    let windowID: UUID
    let onAdd: (Dashboard) -> Void

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("新しいタブ") {
                DashboardForm(onAdd: { dashboard in
                    onAdd(dashboard)
                    dismiss()
                }, onLogInThenAdd: { dashboard in
                    openWindow(value: DashboardLoginRequest(dashboard: dashboard, origin: .dashboardWindow(windowID)))
                    dismiss()
                })
            }
        }
        .formStyle(.grouped)
        .frame(width: 420)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("キャンセル") { dismiss() }
            }
        }
    }
}
