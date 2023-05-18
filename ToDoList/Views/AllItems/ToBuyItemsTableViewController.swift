//
//  ToBuyItemsTableViewController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-19.
//

import UIKit

class ToBuyItemsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var itemListDelegate: ItemListDelegate?
    
    private var allToBuyItems: [ToBuyItem] {
        return itemListDelegate?.toBuyItems ?? []
    }
    private var highPriorityToBuyItems: [ToBuyItem] {
        return allToBuyItems.filter({ $0.isHighPriority })
    }
    private var lowPriorityToBuyItems: [ToBuyItem] {
        return allToBuyItems.filter({ !$0.isHighPriority })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ItemTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
    }
    
    
    private func showDeleteAlertForItem(_ toBuyItem: ToBuyItem) {
        let alertController = UIAlertController(title: Localization.getStringForKey(.removeItemText), message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: Localization.getStringForKey(.yes), style: .destructive, handler: { [weak self] _ in
            let _ = ToBuyItemFunctions.instance.deleteToBuyItem(toBuyItem)
            self?.itemListDelegate?.itemListWasChanged()
        })
        let cancelAction = UIAlertAction(title: Localization.getStringForKey(.no), style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func getItemListForSectionAtIndex(_ index: Int) -> [ToBuyItem] {
        switch index {
        case 0:
            return highPriorityToBuyItems
        case 1:
            return lowPriorityToBuyItems
        default:
            return allToBuyItems
        }
    }
}


// MARK: - Table view stuff


extension ToBuyItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = section == 0 ? highPriorityToBuyItems : lowPriorityToBuyItems
        return items.count
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Localization.getStringForKey(.highPriorityTitle)
        } else {
            return Localization.getStringForKey(.lowPriorityTitle)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        section == 1 ? TableViewFooterView() : nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == 1 ? UIConstants.tableViewFooterHeight : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        let itemList = getItemListForSectionAtIndex(indexPath.section)
        let toBuyItem = itemList[indexPath.row]
        
        cell.itemName = toBuyItem.name
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
