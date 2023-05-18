//
//  MainTabBarController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-19.
//

import UIKit

class MainTabBarController: UITabBarController {

    private enum Segues: String {
        case embedTodaysAgendaSegue
        case embedAllItemsSegue
    }
    
    private var allItemsVC: AllItemsViewController? {
        return children.first(where: { $0 is AllItemsViewController }) as? AllItemsViewController
    }
    private var todaysAgendaVC: TodaysAgendaViewController? {
        return children.first(where: { $0 is TodaysAgendaViewController }) as? TodaysAgendaViewController
    }
        
    weak var itemListDelegate: ItemListDelegate?
    
    private var previousItemsListMode: ItemListMode = .toDoItems
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allItemsVC?.itemListDelegate = itemListDelegate
        todaysAgendaVC?.itemListDelegate = itemListDelegate
    }

    
    override func viewWillLayoutSubviews() {
        setUpTabBar()
    }
    
    
    func setUpTabBar() {
        // Set frame
        let tabBarY = view.frame.size.height - UIConstants.tabBarHeight
        var tabBarFrame = tabBar.frame
        tabBarFrame.size.height = UIConstants.tabBarHeight
        tabBarFrame.origin.y = tabBarY
        tabBar.frame = tabBarFrame

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIConstants.mainAccentColour
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIConstants.unselectedTabBarColour
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : UIConstants.unselectedTabBarColour]
            appearance.stackedLayoutAppearance.selected.iconColor = UIConstants.selectedTabBarColour
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor : UIConstants.selectedTabBarColour]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            
        } else {
            tabBar.backgroundColor = UIConstants.mainAccentColour
            tabBar.unselectedItemTintColor = UIConstants.unselectedTabBarColour
        }

        // Add line view
        let lineView = LineView(superViewFrame: tabBar.frame, yPos: 0)
        tabBar.addSubview(lineView)
    }

    
    func reloadTableViews() {
        allItemsVC?.reloadData()
        todaysAgendaVC?.reloadData()
    }

}


extension MainTabBarController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let itemListMode = itemListDelegate?.itemListMode,
                let newSelectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        
        if newSelectedIndex == selectedIndex { return }
        
        if newSelectedIndex == 0 {
            previousItemsListMode = itemListMode
            itemListDelegate?.itemListMode = .todaysAgenda
        } else {
            itemListDelegate?.itemListMode = previousItemsListMode
        }
    }

}
