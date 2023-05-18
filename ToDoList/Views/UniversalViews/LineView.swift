//
//  LineView.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-03-21.
//

import UIKit

class LineView: UIView {

    init(superViewFrame: CGRect, xPos: CGFloat? = nil, yPos: CGFloat? = nil, width: CGFloat? = nil) {
        let finalX = xPos ?? superViewFrame.minX
        let finalY = yPos ?? superViewFrame.minY
        let finalWidth = width ?? superViewFrame.width
        let finalHeight: CGFloat = UIConstants.lineHeight
        let finalFrame = CGRect(x: finalX, y: finalY, width: finalWidth, height: finalHeight)
        super.init(frame: finalFrame)
        
        backgroundColor = UIConstants.lineViewColour
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
