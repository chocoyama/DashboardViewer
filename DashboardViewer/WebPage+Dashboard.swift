import AppKit
import DashboardKit
import WebKit

extension WebPage {
    convenience init(dashboardID: Dashboard.ID, library: DashboardLibrary) {
        // デシジョンハンドラは生成前に渡す必要があるため、自身への参照は生成後に埋める
        weak var page: WebPage?
        let decider = DashboardNavigationDecider(
            currentDashboard: { library.dashboard(id: dashboardID) },
            reopenInDashboard: { page?.load($0) },
            openInDefaultBrowser: { NSWorkspace.shared.open($0) }
        )
        self.init(navigationDecider: decider)
        page = self
    }

    var previousItem: BackForwardList.Item? {
        backForwardList.backList.last
    }

    func goBack() {
        if let previousItem { load(previousItem) }
    }
}
