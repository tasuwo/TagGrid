//
//  Created by Tasuku Tozawa on 2021/10/11.
//

import SwiftUI
import UIKit

extension Font {
    var uiFont: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)

        case .title:
            return UIFont.preferredFont(forTextStyle: .title1)

        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)

        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)

        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)

        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)

        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)

        case .caption:
            return UIFont.preferredFont(forTextStyle: .caption1)

        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2)

        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)

        case .body:
            fallthrough

        default:
            return UIFont.preferredFont(forTextStyle: .body)
        }
    }
}
