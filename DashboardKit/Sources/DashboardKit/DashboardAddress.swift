import Foundation

/// 入力文字列をダッシュボードとして開ける http(s) の URL に変換する。開けない入力は nil。
public func dashboardURL(from text: String) -> URL? {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let url = URL(string: trimmed),
          let scheme = url.scheme?.lowercased(),
          ["http", "https"].contains(scheme),
          url.host() != nil
    else { return nil }
    return url
}
