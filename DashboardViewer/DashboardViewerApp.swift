import DashboardKit
import SwiftUI

@main
struct DashboardViewerApp: App {
    @State private var library = DashboardLibrary()

    var body: some Scene {
        Window("ダッシュボード一覧", id: DashboardLibraryWindow.id) {
            DashboardLibraryView()
                .environment(library)
        }

        WindowGroup(for: Dashboard.ID.self) { $id in
            DashboardWindow(id: id)
                .environment(library)
        }
        .windowStyle(.hiddenTitleBar)
        .commands { DashboardCommands() }

        WindowGroup("ログイン", for: Dashboard.self) { $dashboard in
            if let dashboard {
                DashboardLoginView(dashboard: dashboard)
                    .environment(library)
            }
        }
    }
}
