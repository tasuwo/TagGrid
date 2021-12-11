//
//  Created by Tasuku Tozawa on 2021/10/10.
//

import Foundation
import SwiftUI

public struct TagCell: View {
    // MARK: - Properties
    
    private let tag: Tag
    private let status: Status
    private let size: Size
    
    private let onSelect: ((UUID) -> Void)?
    private let onDelete: ((UUID) -> Void)?

    @ScaledMetric private var padding: CGFloat
    
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(size.font)
            .aspectRatio(contentMode: .fit)
    }
    
    private var bodyContainer: some View {
        HStack(spacing: 0) {
            if status.isSelected {
                checkmark
                    .foregroundColor(.white)
                    .padding([.trailing], 2)
            } else {
                // frameサイズを合わせるため、チェックマークをベースにする
                checkmark
                    .foregroundColor(.clear)
                    .overlay(
                        Text("#")
                            .font(size.font)
                            .padding(.all, 0)
                            .scaleEffect(1.2)
                    )
                    .padding([.trailing], 2)
            }

            HStack(spacing: 4) {
                Text(tag.name)
                    .foregroundColor(status.isSelected ? .white : .primary)
                    .font(size.font)
                    .lineLimit(1)

                Text("(\(tag.count))")
                    .foregroundColor(status.isSelected ? .white : .secondary)
                    .font(size.font)
                    .lineLimit(1)
            }
        }
    }

    private var deleteButtonContainer: some View {
        Button {
            onDelete?(tag.id)
        } label: {
            Image(systemName: "xmark")
                .font(size.font)
        }
        .padding([.leading, .trailing], padding)
    }
    
    // MARK: - Initializers
    
    public init(tag: Tag,
                status: Status,
                size: Size = .normal,
                onSelect: ((UUID) -> Void)? = nil,
                onDelete: ((UUID) -> Void)? = nil)
    {
        self.tag = tag
        self.status = status
        self.size = size
        self.onSelect = onSelect
        self.onDelete = onDelete
        self._padding = ScaledMetric(wrappedValue: size.padding)
    }

    // MARK: - View

    public var body: some View {
        HStack(spacing: 0) {
            bodyContainer
                .padding(.horizontal, padding * 3 / 2)
                .padding(.vertical, padding)
                .overlay(GeometryReader { geometry in
                    if status.isDeletable {
                        Divider()
                            .background(Color("tag_background", bundle: Bundle.module))
                            .offset(x: geometry.size.width)
                            .padding([.top, .bottom], padding)
                    } else {
                        Color.clear
                    }
                })

            if status.isDeletable {
                deleteButtonContainer
            }
        }
        .background(GeometryReader { geometry in
            let baseView = status.isSelected
                ? Color.green
                : Color("tag_background", bundle: Bundle.module)
            baseView
                .clipShape(RoundedRectangle(cornerRadius: geometry.size.height / 2,
                                            style: .continuous))
        })
        .overlay(GeometryReader { geometry in
            if status.isSelected {
                Color.clear
            } else {
                RoundedRectangle(cornerRadius: geometry.size.height / 2,
                                 style: .continuous)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(Color("tag_separator", bundle: Bundle.module))
            }
        })
        .onTapGesture {
            onSelect?(tag.id)
        }
    }

    // MARK: - Methods

    static func preferredSize(tag: Tag, size: TagCell.Size, isDeletable: Bool) -> CGSize {
        let font = size.font
        let padding = size.padding.scaledValue(for: font)

        let markSize = String.labelSizeOfSymbol(systemName: "checkmark", withFont: font)
        let tagNameSize = tag.name.labelSize(withFont: font)
        let countLabelSize = "(\(tag.count))".labelSize(withFont: font)

        let cellHeight = max(markSize.height, tagNameSize.height, countLabelSize.height) + padding * 2

        let bodyWidth = markSize.width + 2 + tagNameSize.width + 4 + countLabelSize.width
        let horizontalPadding = padding * 3 / 2
        var cellWidth = bodyWidth + horizontalPadding * 2

        if isDeletable {
            cellWidth += padding * 2 + String.labelSizeOfSymbol(systemName: "xmark", withFont: font).width
        }

        return CGSize(width: cellWidth, height: cellHeight)
     }
}

// MARK: - Preview

struct TagCell_Previews: PreviewProvider {
    struct Container: View {
        @State var selected: UUID?
        @State var deleted: UUID?

        var body: some View {
            VStack(spacing: 8) {
                HStack {
                    TagCell(tag: Tag(id: UUID(), name: "タグ", count: 5),
                            status: .default,
                            onSelect: { selected = $0 })
                    TagCell(tag: Tag(id: UUID(), name: "my tag", count: 5),
                            status: .selected,
                            onSelect: { selected = $0 })
                    TagCell(tag: Tag(id: UUID(), name: "😁", count: 5),
                            status: .deletable,
                            onSelect: { selected = $0 },
                            onDelete: { deleted = $0 })
                }

                HStack {
                    TagCell(tag: Tag(id: UUID(), name: "タグ", count: 5),
                            status: .default,
                            size: .small,
                            onSelect: { selected = $0 })
                    TagCell(tag: Tag(id: UUID(), name: "my tag", count: 5),
                            status: .selected,
                            size: .small,
                            onSelect: { selected = $0 })
                    TagCell(tag: Tag(id: UUID(), name: "😁", count: 5),
                            status: .deletable,
                            size: .small,
                            onSelect: { selected = $0 },
                            onDelete: { deleted = $0 })
                }

                if let selected = selected {
                    Text("Selected: id=\(selected.uuidString)")
                        .foregroundColor(.gray)
                        .font(.callout)
                        .padding([.trailing, .leading])
                }

                if let deleted = deleted {
                    Text("Deleted: id=\(deleted.uuidString)")
                        .foregroundColor(.gray)
                        .font(.callout)
                        .padding([.trailing, .leading])
                }
            }
        }
    }

    static var previews: some View {
        Group {
            Container()
                .preferredColorScheme(.light)

            Container()
                .preferredColorScheme(.light)
                .environment(\.sizeCategory, .extraSmall)

            Container()
                .preferredColorScheme(.light)
                .environment(\.sizeCategory, .extraLarge)

            Container()
                .preferredColorScheme(.dark)
        }
    }
}
