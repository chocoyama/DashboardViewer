import Foundation

public struct Dashboard: Codable, Hashable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var url: URL
    public var inAppNavigationScope: InAppNavigationScope

    public init(id: UUID = UUID(), name: String, url: URL, inAppNavigationScope: InAppNavigationScope = .dashboardPage) {
        self.id = id
        self.name = name
        self.url = url
        self.inAppNavigationScope = inAppNavigationScope
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, url, inAppNavigationScope
    }

    // 設定が導入される前に保存された登録を読めるようにする。キーが無いのは「登録ページのみ」を選んでいた状態と同じ
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(URL.self, forKey: .url)
        inAppNavigationScope = try container.decodeIfPresent(InAppNavigationScope.self, forKey: .inAppNavigationScope)
            ?? .dashboardPage
    }
}
