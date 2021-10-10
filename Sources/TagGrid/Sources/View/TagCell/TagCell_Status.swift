//
//  Created by Tasuku Tozawa on 2021/10/10.
//

public extension TagCell {
    enum Status {
        case `default`
        case selected
        case deletable

        public var isSelected: Bool {
            switch self {
            case .selected:
                return true

            default:
                return false
            }
        }

        public var isDeletable: Bool {
            switch self {
            case .deletable:
                return true

            default:
                return false
            }
        }
    }
}
