//
//  FlowHStack.swift
//  Musician's Log
//
//  Created by Bryce Sechrist on 12/25/24.
//

import SwiftUI

// Borrowed from https://stackoverflow.com/questions/59129890/implementing-a-tag-list-in-swiftui

struct FlowHStack: Layout {
    var horizontalSpacing: CGFloat = 10
    
    var verticalSpacing: CGFloat = 30

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let subviewSizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxSubviewHeight = subviewSizes.map { $0.height }.max() ?? .zero
        var currentRowWidth: CGFloat = .zero
        var totalHeight: CGFloat = maxSubviewHeight
        var totalWidth: CGFloat = .zero

        for size in subviewSizes {
            let requestedRowWidth = currentRowWidth + horizontalSpacing + size.width
            let availableRowWidth = proposal.width ?? .zero
            let willOverflow = requestedRowWidth > availableRowWidth

            if willOverflow {
                totalHeight += verticalSpacing + maxSubviewHeight
                currentRowWidth = size.width
            } else {
                currentRowWidth = requestedRowWidth
            }

            totalWidth = max(totalWidth, currentRowWidth)
        }

        return CGSize(width: totalWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let subviewSizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxSubviewHeight = subviewSizes.map { $0.height }.max() ?? .zero
        var point = CGPoint(x: bounds.minX, y: bounds.minY)

        for index in subviews.indices {
            let requestedWidth = point.x + subviewSizes[index].width
            let availableWidth = bounds.maxX
            let willOverflow = requestedWidth > availableWidth

            if willOverflow {
                point.x = bounds.minX
                point.y += maxSubviewHeight + verticalSpacing
            }

            subviews[index].place(at: point, proposal: ProposedViewSize(subviewSizes[index]))
            point.x += subviewSizes[index].width + horizontalSpacing
        }
    }
}
