//
//  UIConstants.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-03-15.
//

import UIKit


class UIConstants {
    
    // Colours
    // Main colours
    static let mainBackgroundColour = UIColor(red: 77/255, green: 165/255, blue: 232/255, alpha: 0.4)
    static let mainAccentColour = UIColor(red: 77/255, green: 165/255, blue: 232/255, alpha: 0.8)
    static let lineViewColour = UIColor.lightGray.withAlphaComponent(0.5)
    // Table view cell
    static let cellBackgroundColour = UIColor.white
    static let selectedCellBackgroundColour = UIColor(red: 77/255, green: 165/255, blue: 232/255, alpha: 0.6)
    // Controls
    static let selectedSegmentColour = UIColor.white
    static let unselectedSegmentColour = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.5)
    static let selectedControlColour = UIColor(red: 77/255, green: 165/255, blue: 232/255, alpha: 1.0)
    static let unselectedControlColour = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 0.5)
    static let selectedTabBarColour = UIColor.black
    static let unselectedTabBarColour = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1.0)
    // Texts
    static let offBlack = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0)
    

    // Sizes
    static let screenWidth = UIScreen.main.bounds.size.width
    static let lineHeight: CGFloat = 1
    
    static let tableViewCellHeight: CGFloat = 55
    static let tableViewFooterHeight: CGFloat = 60
    static let tabBarHeight: CGFloat = 60
    
    
    // Image names
    static let trashImage = "trash.fill"
    
    
    // Fonts
    static let segmentedControlFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    private init() {}
    
}


extension UIView {
    
    func addShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
    }
    
}

