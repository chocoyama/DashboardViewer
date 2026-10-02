import DashboardKit
import SwiftUI

struct DashboardLibraryView: View {
    @Environment(DashboardLibrary.self) private var library
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Form {
            Section("追加") {
                DashboardForm(onAdd: { library.add($0) },
                              onLogInThenAdd: { openWindow(value: $0) })
            }
            Section("登録済み") {
                if library.dashboards.isEmpty {
                    Text("まだありません").foregroundStyle(.secondary)
                }
                ForEach(library.dashboards) { dashboard in
                    row(dashboard)
                }
            }
        }
        .formStyle(.grouped)
        .frame(minWidth: 480, minHeight: 360)
    }

    private func row(_ dashboard: Dashboard) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dashboard.name)
                Text(dashboard.url.absoluteString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            Spacer()
            Button("ログイン") { openWindow(value: dashboard) }
            Button("開く") { openWindow(value: dashboard.id) }
            Button("削除", systemImage: "trash", role: .destructive) {
                library.remove(id: dashboard.id)
            }
            .labelStyle(.iconOnly)
        }
    }
}
