//
//  TableViewFooterVIew.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-03-23.
//

import UIKit

class TableViewFooterView: UIView {

    init(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil) {
        let finalX = x ?? 0
        let finalY = y ?? 0
        let finalWidth = width ?? UIConstants.screenWidth
        let height = UIConstants.tableViewFooterHeight
        super.init(frame: CGRect(x: finalX, y: finalY, width: finalWidth, height: height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
