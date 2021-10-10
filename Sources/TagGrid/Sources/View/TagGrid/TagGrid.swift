//
//  Created by Tasuku Tozawa on 2021/10/11.
//

import Foundation
import SwiftUI

public struct TagGrid: View {
    public enum Action {
        case delete(UUID)
        case select(UUID)
    }

    // MARK: - Properties

    @Binding private var tags: [Tag]
    @Binding private var selectedIds: Set<Tag.ID>

    @State private var availableWidth: CGFloat = 0
    @State private var cellSizes: [Tag: CGSize] = [:]

    @Namespace var animation

    private let configuration: Configuration
    private let spacing: CGFloat
    private let inset: CGFloat
    private let onAction: ((Action) -> Void)?

    // MARK: - Initializers

    public init(tags: Binding<[Tag]>,
                selectedIds: Binding<Set<Tag.ID>>,
                configuration: Configuration = .init(.default),
                spacing: CGFloat = 8,
                inset: CGFloat = 8,
                onAction: ((Action) -> Void)? = nil)
    {
        _tags = tags
        _selectedIds = selectedIds
        self.configuration = configuration
        self.spacing = spacing
        self.inset = inset
        self.onAction = onAction
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            Color.clear
                .frame(height: 0)
                .onChangeFrame {
                    availableWidth = $0.width
                }

            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: spacing) {
                        Color.clear
                            .frame(height: 0)
                            .frame(minWidth: 0, maxWidth: .infinity)

                        ForEach(calcRows(), id: \.self) { tags in
                            HStack(spacing: spacing) {
                                ForEach(tags) {
                                    cell(geometry, $0)
                                }
                            }
                        }
                    }
                    .padding(.all, inset)
                }
            }
        }
    }

    private func cell(_ geometry: GeometryProxy, _ tag: Tag) -> some View {
        return TagCell(
            tag: tag,
            status: .init(configuration, isSelected: selectedIds.contains(tag.id)),
            size: configuration.size,
            onSelect: {
                onAction?(.select($0))
            },
            onDelete: {
                onAction?(.delete($0))
            }
        )
        .frame(maxWidth: geometry.size.width - inset * 2)
        .fixedSize()
        .onChangeFrame {
            cellSizes[tag] = $0
        }
        .contextMenu {
            menu(tag)
        }
        .matchedGeometryEffect(id: tag.id, in: animation)
    }

    @ViewBuilder
    private func menu(_ tag: Tag) -> some View {
        if configuration.isEnabledMenu {
            Button(role: .destructive) {
                onAction?(.delete(tag.id))
            } label: {
                Label {
                    Text("Delete")
                } icon: {
                    Image(systemName: "trash")
                }
            }
        } else {
            EmptyView()
        }
    }

    private func calcRows() -> [[Tag]] {
        var rows: [[Tag]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth - inset * 2

        for tag in tags {
            let cellSize = cellSizes[tag, default: CGSize(width: availableWidth - inset * 2, height: 1)]

            if remainingWidth - (cellSize.width + spacing) >= 0 {
                rows[currentRow].append(tag)
            } else {
                currentRow += 1
                rows.append([tag])
                remainingWidth = availableWidth - inset * 2
            }

            remainingWidth -= (cellSize.width + spacing)
        }

        return rows
    }
}

private extension TagCell.Status {
    init(_ config: TagGrid.Configuration, isSelected: Bool) {
        switch config.style {
        case .selectable:
            self = isSelected ? .selected : .default

        case .deletable:
            self = .deletable

        default:
            self = .default
        }
    }
}

// MARK: - Preview

struct TagGrid_Previews: PreviewProvider {
    struct ContentView: View {
        // MARK: - Properties

        @State private var tags: [Tag]
        @State private var selectedIds: Set<Tag.ID> = .init()

        // MARK: - Initializers

        init(tags: [Tag]) {
            self.tags = tags
        }

        // MARK: - View

        public var body: some View {
            VStack {
                Button {
                    withAnimation {
                        tags.insert(Tag(id: UUID(), name: "Added"), at: 0)
                    }
                } label: {
                    Text("Add Tag")
                }

                TagGrid(tags: $tags,
                        selectedIds: $selectedIds,
                        configuration: .init(.selectable(.multiple), isEnabledMenu: true)) { action in
                    switch action {
                    case let .select(tagId):
                        if selectedIds.contains(tagId) {
                            selectedIds.subtract([tagId])
                        } else {
                            selectedIds = selectedIds.union([tagId])
                        }

                    case let .delete(tagId):
                        guard let index = tags.firstIndex(where: { $0.id == tagId }) else { return }
                        _ = withAnimation {
                            tags.remove(at: index)
                        }
                    }
                }
            }
        }
    }

    static let tags: [Tag] = [
        .init(id: UUID(), name: "This"),
        .init(id: UUID(), name: "is"),
        .init(id: UUID(), name: "Flexible"),
        .init(id: UUID(), name: "Gird"),
        .init(id: UUID(), name: "Layout"),
        .init(id: UUID(), name: "for"),
        .init(id: UUID(), name: "Tags."),
        .init(id: UUID(), name: "This"),
        .init(id: UUID(), name: "Layout"),
        .init(id: UUID(), name: "allows"),
        .init(id: UUID(), name: "displaying"),
        .init(id: UUID(), name: "very"),
        .init(id: UUID(), name: "long"),
        .init(id: UUID(), name: "tag"),
        .init(id: UUID(), name: "names"),
        .init(id: UUID(), name: "like"),
        .init(id: UUID(), name: "Too Too Too Too Long Tag"),
        .init(id: UUID(), name: "or"),
        .init(id: UUID(), name: "Toooooooooooooo Loooooooooooooooooooooooong Tag."),
        .init(id: UUID(), name: "All"),
        .init(id: UUID(), name: "cell"),
        .init(id: UUID(), name: "sizes"),
        .init(id: UUID(), name: "are"),
        .init(id: UUID(), name: "flexible")
    ]

    static var previews: some View {
        ContentView(tags: tags)
    }
}
