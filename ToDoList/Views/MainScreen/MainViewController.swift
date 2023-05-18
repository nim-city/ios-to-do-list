//
//  ViewController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-18.
//

import UIKit

// TODO: Need a completion handler to change title label and itemListMode
class MainViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private enum Segues: String {
        case showNewItemSegue
        case showSelectItemsSegue
        case showMainTabBarSegue
    }
    
    private var currentItemListMode: ItemListMode = .todaysAgenda
    
    private var mainTabBarController: MainTabBarController? {
        return children.first(where: { $0 is MainTabBarController }) as? MainTabBarController
    }
    
    private var titleLabelText: String {
        StringUtilityFunctions.getTitleForItemListMode(currentItemListMode)
    }
    
    private var clearItemsLabelText: String {
        StringUtilityFunctions.getClearItemsPopUpText(currentItemListMode)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    
    private func setUpUI() {
        backgroundView.backgroundColor = UIConstants.mainBackgroundColour
        setUpTopView()
    }
    
    
    private func setUpTopView() {
        topView.backgroundColor = UIConstants.mainAccentColour
        // Add line view
        let lineViewY = topView.frame.maxY - 1
        let lineView = LineView(superViewFrame: topView.frame, yPos: lineViewY)
        topView.addSubview(lineView)
    }
    
    
    @IBAction func pressClearButton(_ sender: UIButton) {
        showClearItemsPopUp()
    }
    
    
    @IBAction func pressAddButton(_ sender: UIButton) {
        switch currentItemListMode {
        case .todaysAgenda:
            performSegue(withIdentifier: Segues.showSelectItemsSegue.rawValue, sender: self)
        case .toDoItems, .toBuyItems:
            performSegue(withIdentifier: Segues.showNewItemSegue.rawValue, sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newItemViewController = segue.destination as? NewItemViewController {
            newItemViewController.itemListMode = currentItemListMode
            newItemViewController.itemListDelegate = self
        } else if let selectItemsViewController = segue.destination as? SelectToDoItemsViewController {
            selectItemsViewController.itemListDelegate = self
        } else if let mainTabBarController = segue.destination as? MainTabBarController {
            mainTabBarController.itemListDelegate = self
        }
    }
    
    
    private func updateTitleLabel() {
        titleLabel.text = titleLabelText
    }
    
    
    private func showClearItemsPopUp() {
        let alertController = UIAlertController(title: nil, message: clearItemsLabelText, preferredStyle: .alert)
        let noAction = UIAlertAction(title: Localization.getStringForKey(.no), style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: Localization.getStringForKey(.yes), style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            switch self.currentItemListMode {
            case .todaysAgenda:
                let _ = TodaysAgendaFunctions.instance.clearTodaysAgenda()
            case .toDoItems:
                let _ = ToDoItemFunctions.instance.clearToDoItems()
            case .toBuyItems:
                let _ = ToBuyItemFunctions.instance.clearToBuyItems()
            }
            self.itemListWasChanged()
        })
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true, completion: nil)
    }
}


extension MainViewController: ItemListDelegate {
    
    var itemListMode: ItemListMode {
        get { return currentItemListMode }
        set {
            currentItemListMode = newValue
            updateTitleLabel()
        }
    }
    
    var todaysAgenda: [ToDoItem] {
        return TodaysAgendaFunctions.instance.todaysAgenda ?? []
    }
    
    var toDoItems: [ToDoItem] {
        return ToDoItemFunctions.instance.toDoItems ?? []
    }
    
    var toBuyItems: [ToBuyItem] {
        return ToBuyItemFunctions.instance.toBuyItems ?? []
    }
    
    
    func itemListWasChanged() {
        mainTabBarController?.reloadTableViews()
    }

}
