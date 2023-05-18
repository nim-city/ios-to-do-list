//
//  SelectToDoItemsTableViewController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-19.
//

import UIKit

// TODO: Need to change toDoItems to actual list of ToDoItems
// TODO: Need list of selected items and completion handler to call when done
class SelectToDoItemsViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    weak var itemListDelegate: ItemListDelegate?
    
    private var toDoItems: [ToDoItem] {
        guard let toDoItems = itemListDelegate?.toDoItems else { return [] }
        return toDoItems.filter({ !$0.isOnAgenda })
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
        
        // Set up save button
        saveButton.isEnabled = !selectedItems.isEmpty
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
    
}


// MARK: - Table view data source


extension SelectToDoItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        TableViewFooterView()
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        UIConstants.tableViewFooterHeight
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        let toDoItem = toDoItems[indexPath.row]
        
        cell.itemName = toDoItem.name
        cell.setUpCell(numItems: toDoItems.count, position: indexPath.row)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = toDoItems[indexPath.row]
        selectedItems.append(selectedItem)
        saveButton.isEnabled = !selectedItems.isEmpty
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let unselectedItem = toDoItems[indexPath.row]
        if let itemIndex = selectedItems.firstIndex(of: unselectedItem) {
            selectedItems.remove(at: itemIndex)
        }
        saveButton.isEnabled = !selectedItems.isEmpty
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableViewCellHeight
    }
}
