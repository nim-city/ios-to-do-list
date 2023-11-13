//
//  SelectToDoItemsTableViewController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-19.
//

import UIKit

class SelectToDoItemsViewController: UIViewController {

    private enum Segues: String {
        case showNewItemSegue = "showNewItemSegue"
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addNewItemButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    weak var itemListDelegate: ItemListDelegate?
    
    private var highPriorityToDoItems: [ToDoItem] {
        return itemListDelegate?.toDoItems.filter({ $0.isHighPriority }) ?? []
    }
    private var shortTermToDoItems: [ToDoItem] {
        return itemListDelegate?.toDoItems.filter({ !$0.isHighPriority && !$0.isLongTerm }) ?? []
    }
    private var longTermToDoItems: [ToDoItem] {
        return itemListDelegate?.toDoItems.filter({ $0.isLongTerm && !$0.isHighPriority }) ?? []
    }
    
    private var selectedItems = [ToDoItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ItemTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
        
        setUpUI()
    }
    
    
    private func setUpUI() {
        // Set up top view
        let lineViewY = topView.frame.maxY - 1
        let lineView = LineView(superViewFrame: topView.frame, yPos: lineViewY)
        topView.addSubview(lineView)
        
        // Add new item button
        addNewItemButton.tintColor = UIConstants.offBlack
        
        // Set up save button
        saveButton.isEnabled = !selectedItems.isEmpty
    }
    
    
    private func getItemListForSectionAtIndex(_ index: Int) -> [ToDoItem] {
        switch index {
        case 0:
            return highPriorityToDoItems
        case 1:
            return shortTermToDoItems
        case 2:
            return longTermToDoItems
        default:
            return []
        }
    }
    
    
    @IBAction func pressAddNewItemButton(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.showNewItemSegue.rawValue, sender: self)
    }
    
    
    @IBAction func pressCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pressDoneButton(_ sender: UIButton) {
        let wasSelectionSuccessful = updateSelectedItems()
        if wasSelectionSuccessful {
            itemListDelegate?.itemListWasChanged()
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func updateSelectedItems() -> Bool {
        if selectedItems.isEmpty { return false }
        let wasSelectionSuccessful = TodaysAgendaFunctions.instance.selectItems(selectedItems)
        return wasSelectionSuccessful
    }
    
    
    private func reloadData() {
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newItemViewController = segue.destination as? NewItemViewController {
            newItemViewController.previousViewController = self
            newItemViewController.itemListMode = .toDoItems
            newItemViewController.itemListDelegate = itemListDelegate
            newItemViewController.saveClosure = reloadData
        }
    }

}


// MARK: - Table view data source


extension SelectToDoItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedList = getItemListForSectionAtIndex(section)
        return selectedList.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Localization.getStringForKey(.highPriorityTitle)
        case 1:
            return Localization.getStringForKey(.shortTermTitle)
        case 2:
            return Localization.getStringForKey(.longTermTitle)
        default:
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.headerView(forSection: section)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        section == 2 ? TableViewFooterView() : nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == 2 ? UIConstants.tableViewFooterHeight : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        let itemList = getItemListForSectionAtIndex(indexPath.section)
        
        let toDoItem = itemList[indexPath.row]
        cell.itemName = toDoItem.name
        cell.setUpCell(numItems: itemList.count, position: indexPath.row)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemList = getItemListForSectionAtIndex(indexPath.section)
        let selectedItem = itemList[indexPath.row]
        selectedItems.append(selectedItem)
        saveButton.isEnabled = !selectedItems.isEmpty
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let itemList = getItemListForSectionAtIndex(indexPath.section)
        let unselectedItem = itemList[indexPath.row]
        if let itemIndex = selectedItems.firstIndex(of: unselectedItem) {
            selectedItems.remove(at: itemIndex)
        }
        saveButton.isEnabled = !selectedItems.isEmpty
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableViewCellHeight
    }
}
