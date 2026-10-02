import Foundation

public enum NavigationRoute: Equatable, Sendable {
    case stayInDashboard
    case openInDefaultBrowser
}

/// ダッシュボードはメインフレームで指定 URL だけを表示し、それ以外の遷移はデフォルトブラウザへ回す。
/// iframe はページの構成要素なので内部で読み込む。
public func navigationRoute(to destination: URL, in frame: NavigationFrame, dashboardURL: URL) -> NavigationRoute {
    switch frame {
    case .subframe:
        return .stayInDashboard
    case .newWindow:
        return .openInDefaultBrowser
    case .mainFrame:
        return destination.removingFragment == dashboardURL.removingFragment ? .stayInDashboard : .openInDefaultBrowser
    }
}

private extension URL {
    // フラグメントの変化は同一ページ内のスクロールで、別ページへの遷移ではない
    var removingFragment: URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
        components.fragment = nil
        return components.url ?? self
    }
}
