//
//  Created by Tasuku Tozawa on 2021/10/11.
//

import SwiftUI
import UIKit

extension Font {
    var uiFont: UIFont {
        return UIFont.preferredFont(forTextStyle: self.uiTextStyle)
    }

    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:
            return .largeTitle

        case .title:
            return .title1

        case .title2:
            return .title2

        case .title3:
            return .title3

        case .headline:
            return .headline

        case .subheadline:
            return .subheadline

        case .callout:
            return .callout

        case .caption:
            return .caption1

        case .caption2:
            return .caption2

        case .footnote:
            return .footnote

        case .body:
            fallthrough

        default:
            return .body
        }
    }
}
