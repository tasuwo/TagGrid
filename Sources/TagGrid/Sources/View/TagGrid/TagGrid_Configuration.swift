//
//  Created by Tasuku Tozawa on 2021/10/11.
//

public extension TagGrid {
    struct Configuration: Equatable {
        public enum Style: Equatable {
            public enum SelectionStyle: Equatable {
                case single
                case multiple
            }

            case `default`
            case deletable
            case selectable(SelectionStyle)
        }

        // MARK: - Properties

        public let style: Style
        public let size: TagCell.Size
        public let isEnabledMenu: Bool

        // MARK: - Initializers

        public init(_ style: Style,
                    size: TagCell.Size = .normal,
                    isEnabledMenu: Bool = false)
        {
            self.style = style
            self.size = size
            self.isEnabledMenu = isEnabledMenu
        }
    }
}
