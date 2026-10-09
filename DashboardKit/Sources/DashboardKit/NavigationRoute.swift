import Foundation

public enum NavigationRoute: Equatable, Sendable {
    case stayInDashboard
    case reopenInDashboard
    case openInDefaultBrowser
}

public func navigationRoute(to destination: URL, in frame: NavigationFrame, isUserInitiated: Bool = true,
                            dashboardURL: URL, scope: InAppNavigationScope) -> NavigationRoute {
    let isInScope = scope.contains(destination, dashboardURL: dashboardURL)
    switch frame {
    case .subframe:
        // iframe はページの構成要素なので、範囲外でも内部で読み込む
        return .stayInDashboard
    case .newWindow:
        return isInScope ? .reopenInDashboard : .openInDefaultBrowser
    case .mainFrame:
        // セッション切れによるリダイレクトなどは自動再読み込みのたびに起きるため、ブラウザへ回すとタブが溜まり続ける
        return isInScope || !isUserInitiated ? .stayInDashboard : .openInDefaultBrowser
    }
}
