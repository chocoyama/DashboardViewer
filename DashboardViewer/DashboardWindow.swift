import DashboardKit
import SwiftUI
import WebKit

struct DashboardWindow: View {
    @Environment(DashboardLibrary.self) private var library
    @State private var selection: Dashboard.ID?
    @State private var pages: [Dashboard.ID: WebPage] = [:]
    @State private var isAddingDashboard = false
    @State private var windowID = UUID()

    init(id: Dashboard.ID?) {
        _selection = State(initialValue: id)
    }

    private var selectedDashboard: Dashboard? {
        selection.flatMap(library.dashboard(id:)) ?? library.dashboards.first
    }

    var body: some View {
        VStack(spacing: 0) {
            titleBarStrip
            if let selectedDashboard {
                webViews(showing: selectedDashboard)
                    .navigationTitle(selectedDashboard.name)
            } else {
                ContentUnavailableView("ダッシュボードがありません", systemImage: "rectangle.dashed",
                                       description: Text("一覧から追加してください"))
            }
        }
        .ignoresSafeArea(edges: .top)
        .frame(minWidth: 480, minHeight: 320)
        .onChange(of: selectedDashboard, initial: true) { _, dashboard in
            if let dashboard, pages[dashboard.id] == nil {
                pages[dashboard.id] = WebPage(dashboard: dashboard)
            }
        }
        .onReceive(NotificationCenter.default.finishedDashboardLogins) { request in
            pages[request.dashboard.id]?.reload()
            if request.origin == .dashboardWindow(windowID) {
                selection = request.dashboard.id
            }
        }
        .focusedSceneValue(\.selectedDashboardLoginRequest, selectedDashboard.map {
            DashboardLoginRequest(dashboard: $0, origin: .dashboardWindow(windowID))
        })
        .focusedSceneValue(\.selectedDashboardPage, selectedDashboard.flatMap { pages[$0.id] })
        .focusedSceneValue(\.isAddingDashboard, $isAddingDashboard)
        .sheet(isPresented: $isAddingDashboard) {
            DashboardAdditionSheet(windowID: windowID) { dashboard in
                library.add(dashboard)
                selection = dashboard.id
            }
        }
    }

    // 隠したタイトルバーの領域。信号機ボタンを避けて置き、ウインドウのドラッグ領域も兼ねる
    private var titleBarStrip: some View {
        DashboardTabBar(dashboards: library.dashboards.count > 1 ? library.dashboards : [],
                        selection: Binding(get: { selectedDashboard?.id }, set: { selection = $0 }),
                        onAdd: { isAddingDashboard = true })
            .padding(.leading, 84)
            .padding(.trailing, 12)
            .frame(height: 32)
    }

    // 一度開いたページは保持し、タブを切り替えても再読み込みさせない
    private func webViews(showing selected: Dashboard) -> some View {
        ZStack {
            ForEach(library.dashboards) { dashboard in
                if let page = pages[dashboard.id] {
                    let isSelected = dashboard.id == selected.id
                    DashboardWebView(dashboard: dashboard, page: page)
                        .opacity(isSelected ? 1 : 0)
                        .allowsHitTesting(isSelected)
                }
            }
        }
    }
}
