//
//  ItemTableViewCell.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-21.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ITEM_TABLE_VIEW_CELL"
    static let nibName = "ItemTableViewCell"
    
    @IBOutlet weak var label: UILabel!
    
    private let cornerRadius: CGFloat = 15
    
    var itemName: String? {
        didSet {
            label.text = itemName
        }
    }
    
    
    func setUpCell(numItems: Int, position: Int) {
        backgroundColor = UIConstants.cellBackgroundColour
        setCornerRadius(numItems: numItems, position: position)
    }

    
    private func setCornerRadius(numItems: Int, position: Int) {
        resetCornerRadius()
        if numItems == 0 {
            return
        } else if numItems == 1 {
            setAllCornerRadius()
        } else {
            if position == 0 {
                setTopCornerRadius()
            } else if position == (numItems - 1) {
                setBottomCornerRadius()
            }
        }
    }
    
    
    private func resetCornerRadius() {
        layer.cornerRadius = 0
        layer.maskedCorners = []
    }
    
    
    private func setTopCornerRadius() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    private func setBottomCornerRadius() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    
    private func setAllCornerRadius() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        selectedBackgroundView?.backgroundColor = UIConstants.selectedCellBackgroundColour
    }

}
