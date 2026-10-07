import Foundation

public enum InAppNavigationScope: Codable, Hashable, Sendable {
    case dashboardPage
    case sameHost
    case domainAndSubdomains(String)

    func contains(_ destination: URL, dashboardURL: URL) -> Bool {
        switch self {
        case .dashboardPage:
            return destination.removingFragment == dashboardURL.removingFragment
        case .sameHost:
            return destination.normalizedHost != nil && destination.normalizedHost == dashboardURL.normalizedHost
        case .domainAndSubdomains(let domain):
            guard let host = destination.normalizedHost else { return false }
            return host == domain || host.hasSuffix("." + domain)
        }
    }
}

// 公開サフィックス（co.jp など）は判別できないため、親ドメインを全て並べてどこまで含めるかは利用者に選ばせる
public func selectableDomains(for url: URL) -> [String] {
    guard let host = url.normalizedHost, !host.contains(":") else { return [] }
    let labels = host.split(separator: ".").map(String.init)
    guard labels.count >= 2, Int(labels.last!) == nil else { return [] }
    return (0...(labels.count - 2)).map { labels[$0...].joined(separator: ".") }
}

extension URL {
    // フラグメントの変化は同一ページ内のスクロールで、別ページへの遷移ではない
    var removingFragment: URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
        components.fragment = nil
        return components.url ?? self
    }

    var normalizedHost: String? {
        host()?.lowercased()
    }
}
