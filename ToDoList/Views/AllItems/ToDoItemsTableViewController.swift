//
//  ToDoItemsTableViewController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-19.
//

import UIKit

class ToDoItemsViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ItemTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
    }
    
    
    private func showDeleteAlertForItem(_ toDoItem: ToDoItem) {
        let alertController = UIAlertController(title: Localization.getStringForKey(.deleteItemText), message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: Localization.getStringForKey(.yes), style: .destructive, handler: { [weak self] _ in
            let _ = ToDoItemFunctions.instance.deleteToDoItem(toDoItem)
            self?.itemListDelegate?.itemListWasChanged()
        })
        let cancelAction = UIAlertAction(title: Localization.getStringForKey(.no), style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
}


// MARK: - Table view stuff


extension ToDoItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        section == 2 ? TableViewFooterView() : nil
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.headerView(forSection: section)
        return view
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIConstants.tableViewCellHeight
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: Localization.getStringForKey(.delete), handler: { [weak self] _, _, _ in
            guard let self = self else { return }
            let itemList = self.getItemListForSectionAtIndex(indexPath.section)
            let itemToDelete = itemList[indexPath.row]
            self.showDeleteAlertForItem(itemToDelete)
        })
        deleteSwipeAction.image = UIImage(systemName: UIConstants.trashImage)
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteSwipeAction])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        return swipeActionConfiguration
    }

    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
