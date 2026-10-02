import DashboardKit
import SwiftUI

struct DashboardForm: View {
    let onAdd: (Dashboard) -> Void
    let onLogInThenAdd: (Dashboard) -> Void

    @State private var name = ""
    @State private var address = ""

    private var dashboard: Dashboard? {
        dashboardURL(from: address).map { url in
            Dashboard(name: name.isEmpty ? url.host() ?? url.absoluteString : name, url: url)
        }
    }

    var body: some View {
        TextField("名前", text: $name)
        TextField("URL", text: $address, prompt: Text("https://"))
        HStack {
            Spacer()
            Button("ログインしてから追加") { submit(onLogInThenAdd) }
            Button("追加") { submit(onAdd) }
                .keyboardShortcut(.defaultAction)
        }
        .disabled(dashboard == nil)
    }

    private func submit(_ action: (Dashboard) -> Void) {
        guard let dashboard else { return }
        action(dashboard)
        name = ""
        address = ""
    }
}
