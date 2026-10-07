import DashboardKit
import SwiftUI

struct InAppNavigationScopePicker: View {
    let dashboard: Dashboard

    @Environment(DashboardLibrary.self) private var library

    var body: some View {
        Picker("アプリ内で開くページ", selection: scope) {
            Text("登録ページのみ").tag(InAppNavigationScope.dashboardPage)
            if let host = dashboard.url.host() {
                Text("同じホスト（\(host)）").tag(InAppNavigationScope.sameHost)
            }
            ForEach(selectableDomains(for: dashboard.url), id: \.self) { domain in
                Text("\(domain) とサブドメイン").tag(InAppNavigationScope.domainAndSubdomains(domain))
            }
        }
    }

    private var scope: Binding<InAppNavigationScope> {
        Binding(get: { dashboard.inAppNavigationScope }, set: { scope in
            var updated = dashboard
            updated.inAppNavigationScope = scope
            library.update(updated)
        })
    }
}
