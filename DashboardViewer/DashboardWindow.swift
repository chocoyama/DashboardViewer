import DashboardKit
import SwiftUI

struct DashboardWindow: View {
    @Environment(DashboardLibrary.self) private var library
    @State private var selection: Dashboard.ID?
    @State private var loadedIDs: Set<Dashboard.ID> = []

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
                pages(showing: selectedDashboard)
                    .navigationTitle(selectedDashboard.name)
            } else {
                ContentUnavailableView("ダッシュボードがありません", systemImage: "rectangle.dashed",
                                       description: Text("一覧から追加してください"))
            }
        }
        .ignoresSafeArea(edges: .top)
        .frame(minWidth: 480, minHeight: 320)
        .onChange(of: selectedDashboard?.id, initial: true) { _, id in
            if let id { loadedIDs.insert(id) }
        }
    }

    // 隠したタイトルバーの領域。信号機ボタンを避けて置き、ウインドウのドラッグ領域も兼ねる
    private var titleBarStrip: some View {
        DashboardTabBar(dashboards: library.dashboards.count > 1 ? library.dashboards : [],
                        selection: Binding(get: { selectedDashboard?.id }, set: { selection = $0 }))
            .padding(.leading, 84)
            .padding(.trailing, 12)
            .frame(height: 32)
    }

    // 一度開いたページは保持し、タブを切り替えても再読み込みさせない
    private func pages(showing selected: Dashboard) -> some View {
        ZStack {
            ForEach(library.dashboards.filter { loadedIDs.contains($0.id) }) { dashboard in
                let isSelected = dashboard.id == selected.id
                DashboardWebView(dashboard: dashboard)
                    .opacity(isSelected ? 1 : 0)
                    .allowsHitTesting(isSelected)
            }
        }
    }
}
