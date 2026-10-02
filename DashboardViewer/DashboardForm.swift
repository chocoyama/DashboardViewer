import DashboardKit
import SwiftUI

struct DashboardForm: View {
    let onAdd: (Dashboard) -> Void

    @State private var name = ""
    @State private var address = ""

    private var url: URL? { dashboardURL(from: address) }

    var body: some View {
        TextField("名前", text: $name)
        TextField("URL", text: $address, prompt: Text("https://"))
        Button("追加") {
            guard let url else { return }
            onAdd(Dashboard(name: name.isEmpty ? url.host() ?? url.absoluteString : name, url: url))
            name = ""
            address = ""
        }
        .disabled(url == nil)
    }
}
