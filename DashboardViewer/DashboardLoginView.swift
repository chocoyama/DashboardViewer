import DashboardKit
import SwiftUI
import WebKit

/// 遷移を制限しない。ログイン状態は既定の WebsiteDataStore に残り、ダッシュボード画面と共有されるため。
struct DashboardLoginView: View {
    let request: DashboardLoginRequest

    @Environment(DashboardLibrary.self) private var library
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.dismiss) private var dismiss
    @State private var page = WebPage()

    private var dashboard: Dashboard { request.dashboard }

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
            Button("戻る", systemImage: "chevron.backward") { page.goBack() }
                .disabled(page.previousItem == nil)
        }
        ToolbarItem(placement: .primaryAction) {
            Button("ログイン完了") { finishLogin() }
        }
    }

    private func finishLogin() {
        if library.dashboard(id: dashboard.id) == nil {
            library.add(dashboard)
        }
        NotificationCenter.default.postDashboardLoginDidFinish(request)
        // ダッシュボードのウインドウから来た場合は、そのウインドウが通知を受けてタブを切り替える
        if request.origin == .library {
            OpenDashboardAction(openWindow: openWindow, dismissWindow: dismissWindow)(dashboard.id)
        }
        dismiss()
    }
}
