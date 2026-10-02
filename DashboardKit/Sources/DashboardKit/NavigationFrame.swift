/// ナビゲーションの読み込み先。
public enum NavigationFrame: Sendable {
    case mainFrame
    case subframe
    /// target="_blank" や window.open による新規ウインドウ
    case newWindow
}
