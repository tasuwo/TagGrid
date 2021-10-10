//
//  Created by Tasuku Tozawa on 2021/10/10.
//

import Foundation

public struct Tag: Equatable, Identifiable, Hashable {
    // MARK: - Properties

    public let id: UUID
    public let name: String
    public let count: Int

    // MARK: - Initializers

    public init(id: UUID, name: String, count: Int = 0) {
        self.id = id
        self.name = name
        self.count = count
    }
}
