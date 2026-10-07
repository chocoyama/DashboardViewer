import DashboardKit
import SwiftUI

/// コンテンツを主役にするため、背景を持たず文字の濃淡だけで選択中を示す。
struct DashboardTabBar: View {
    let dashboards: [Dashboard]
    @Binding var selection: Dashboard.ID?
    let onMove: (_ id: Dashboard.ID, _ destinationID: Dashboard.ID) -> Void
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            ForEach(Array(dashboards.enumerated()), id: \.element.id) { index, dashboard in
                DashboardTab(title: dashboard.name, isSelected: dashboard.id == selection) {
                    selection = dashboard.id
                }
                .keyboardShortcut(tabShortcut(at: index))
                .contextMenu { InAppNavigationScopePicker(dashboard: dashboard) }
                .draggable(dashboard.id.uuidString)
                .dropDestination(for: String.self) { ids, _ in
                    guard let id = ids.first.flatMap(UUID.init(uuidString:)) else { return false }
                    onMove(id, dashboard.id)
                    return true
                }
            }
            Button("新しいタブ", systemImage: "plus", action: onAdd)
                .labelStyle(.iconOnly)
                .buttonStyle(.plain)
                .foregroundStyle(.tertiary)
                .help("新しいタブ")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func tabShortcut(at index: Int) -> KeyboardShortcut? {
        guard index < 9 else { return nil }
        return KeyboardShortcut(KeyEquivalent(Character(String(index + 1))), modifiers: .command)
    }
}

private struct DashboardTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.callout)
                .fontWeight(isSelected ? .medium : .regular)
                .foregroundStyle(isSelected ? .primary : isHovered ? .secondary : .tertiary)
                .lineLimit(1)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}
