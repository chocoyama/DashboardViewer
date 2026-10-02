import DashboardKit
import SwiftUI
import WebKit

/// 遷移を制限しない。ログイン状態は既定の WebsiteDataStore に残り、ダッシュボード画面と共有されるため。
struct DashboardLoginView: View {
    let dashboard: Dashboard

    @Environment(DashboardLibrary.self) private var library
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.dismiss) private var dismiss
    @State private var page = WebPage()

    var body: some View {
        WebView(page)
            .frame(minWidth: 640, minHeight: 480)
            .navigationTitle("\(dashboard.name) にログイン")
            .navigationSubtitle(page.url?.absoluteString ?? "")
            .toolbar { toolbar }
            .task { page.load(dashboard.url) }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button("戻る", systemImage: "chevron.backward") {
                if let previous = page.backForwardList.backList.last { page.load(previous) }
            }
            .disabled(page.backForwardList.backList.isEmpty)
        }
        ToolbarItem(placement: .primaryAction) {
            Button("ログイン完了") { finishLogin() }
        }
    }

    private func finishLogin() {
        if library.dashboard(id: dashboard.id) == nil {
            library.add(dashboard)
        }
        OpenDashboardAction(openWindow: openWindow, dismissWindow: dismissWindow)(dashboard.id)
        dismiss()
    }
}
