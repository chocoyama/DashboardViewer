import Foundation

public struct Dashboard: Codable, Hashable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var url: URL

    public init(id: UUID = UUID(), name: String, url: URL) {
        self.id = id
        self.name = name
        self.url = url
    }
}
