//
//  Created by Tasuku Tozawa on 2021/10/11.
//

import CoreGraphics
import SwiftUI
import UIKit

extension CGFloat {
    func scaledValue(for font: Font) -> CGFloat {
        return UIFontMetrics(forTextStyle: font.uiTextStyle).scaledValue(for: self)
    }
}
