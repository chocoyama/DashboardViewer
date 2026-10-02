import DashboardKit
import SwiftUI

@main
struct DashboardViewerApp: App {
    @State private var library = DashboardLibrary()

    var body: some Scene {
        Window("ダッシュボード一覧", id: "library") {
            DashboardLibraryView()
                .environment(library)
        }

        WindowGroup(for: Dashboard.ID.self) { $id in
            DashboardWindow(id: id)
                .environment(library)
        }

        WindowGroup("ログイン", for: Dashboard.self) { $dashboard in
            if let dashboard {
                DashboardLoginView(dashboard: dashboard)
                    .environment(library)
            }
        }
    }
}
