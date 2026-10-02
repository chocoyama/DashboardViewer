import DashboardKit
import SwiftUI

struct DashboardWindow: View {
    let id: Dashboard.ID?

    @Environment(DashboardLibrary.self) private var library

    var body: some View {
        if let dashboard = id.flatMap(library.dashboard(id:)) {
            DashboardWebView(dashboard: dashboard)
                .navigationTitle(dashboard.name)
        } else {
            ContentUnavailableView("ダッシュボードが見つかりません", systemImage: "rectangle.dashed",
                                   description: Text("一覧から削除された可能性があります"))
        }
    }
}
