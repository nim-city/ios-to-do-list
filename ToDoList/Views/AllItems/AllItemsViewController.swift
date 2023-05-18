//
//  AllItemsViewController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-19.
//

import UIKit

class AllItemsViewController: UIViewController {

    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var viewBehindSegmentedControl: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    private var toDoItemsVC: ToDoItemsViewController? {
        return children.first(where: { $0 is ToDoItemsViewController }) as? ToDoItemsViewController
    }
    private var toBuyItemsVC: ToBuyItemsViewController? {
        return children.first(where: { $0 is ToBuyItemsViewController }) as? ToBuyItemsViewController
    }
    
    weak var itemListDelegate: ItemListDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        toDoItemsVC?.itemListDelegate = itemListDelegate
        toBuyItemsVC?.itemListDelegate = itemListDelegate
        
        setUpSegmentedControl()
    }
    
    
    private func setUpSegmentedControl() {
        // Set up view behind segmented control
        viewBehindSegmentedControl.backgroundColor = .white
        viewBehindSegmentedControl.layer.cornerRadius = segmentedControl.layer.cornerRadius
        viewBehindSegmentedControl.clipsToBounds = true
        
        // Set up segmented control
        segmentedControl.backgroundColor = UIConstants.unselectedSegmentColour
        segmentedControl.setTitleTextAttributes([.font: UIConstants.segmentedControlFont], for: .normal)
    }
    
    
    func reloadData() {
        toDoItemsVC?.tableView.reloadData()
        toBuyItemsVC?.tableView.reloadData()
    }
    
    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        setItemListMode(forIndex: selectedIndex)
        setScrollViewOffset(toIndex: selectedIndex)
    }
    
    
    private func setItemListMode(forIndex index: Int) {
        switch index {
        case 0:
            itemListDelegate?.itemListMode = .toDoItems
        case 1:
            itemListDelegate?.itemListMode = .toBuyItems
        default:
            return
        }
    }
    
    
    private func setScrollViewOffset(toIndex index: Int) {
        let screenWidth = UIScreen.main.bounds.size.width
        let newXPosition = screenWidth * CGFloat(index)
        let contentOffset = CGPoint(x: newXPosition, y: 0)
        horizontalScrollView.setContentOffset(contentOffset, animated: true)
    }
}
