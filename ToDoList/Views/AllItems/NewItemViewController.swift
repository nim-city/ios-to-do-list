//
//  NewItemViewController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-19.
//

import UIKit

class NewItemViewController: UIViewController {

    @IBOutlet weak var foregroundView: UIView!
    @IBOutlet weak var newItemLabel: UILabel!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var isHighPrioritySwitch: UISwitch!
    @IBOutlet weak var isLongTermSwitch: UISwitch!
    @IBOutlet weak var isLongTermView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let foregroundViewOffset: CGFloat = -80
    
    var itemListMode: ItemListMode = .toDoItems
    
    weak var itemListDelegate: ItemListDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    
    private func setUpUI() {
        // Set foreground view border
        foregroundView.layer.borderWidth = 3
        foregroundView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Set up title label
        if itemListMode == .toBuyItems {
            newItemLabel.text = Localization.getStringForKey(.newToBuyItemTitle)
        } else {
            newItemLabel.text = Localization.getStringForKey(.newToDoItemTitle)
        }
        
        // Set up name text field
        itemNameTextField.layer.borderColor = UIConstants.unselectedControlColour.cgColor
        itemNameTextField.layer.borderWidth = 2
        itemNameTextField.layer.cornerRadius = 10
        itemNameTextField.clipsToBounds = true
        itemNameTextField.delegate = self
        
        // Set up isLongTermView
        let isHidden = itemListMode == .toBuyItems
        isLongTermView.isHidden = isHidden
        
        // Set up switches
        isHighPrioritySwitch.onTintColor = UIConstants.selectedControlColour
        isLongTermSwitch.onTintColor = UIConstants.selectedControlColour
        
        // Set up buttons
        saveButton.backgroundColor = UIConstants.selectedControlColour
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        cancelButton.setTitleColor(UIConstants.selectedControlColour, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewItemViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewItemViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y += foregroundViewOffset
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y -= foregroundViewOffset
        }
    }
    
    
    @IBAction func pressSaveButton(_ sender: UIButton) {
        let wasSaveSuccessful = itemListMode == .toBuyItems ? saveToBuyItem() : saveToDoItem()
        if wasSaveSuccessful {
            itemListDelegate?.itemListWasChanged()
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func saveToDoItem() -> Bool {
        guard let name = itemNameTextField.text, !name.isEmpty else { return false }
        let isHighPriority = isHighPrioritySwitch.isOn
        let isLongTerm = isLongTermSwitch.isOn
        return ToDoItemFunctions.instance.addToDoItem(itemName: name, isHighPriority: isHighPriority, isLongTerm: isLongTerm)
    }
    
    
    private func saveToBuyItem() -> Bool {
        let name = itemNameTextField.text ?? ""
        let isHighPriority = isHighPrioritySwitch.isOn
        return ToBuyItemFunctions.instance.addToBuyItem(itemName: name, isHighPriority: isHighPriority)
    }
    
    
    @IBAction func pressCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
   
 
    @IBAction func tapBackgroundView(_ sender: UITapGestureRecognizer) {
        if itemNameTextField.isEditing {
            itemNameTextField.endEditing(true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapForegroundView(_ sender: Any) {
        itemNameTextField.endEditing(true)
    }
    
}


extension NewItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIConstants.selectedControlColour.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let borderColour = (textField.text ?? "").isEmpty ? UIConstants.unselectedControlColour.cgColor : UIConstants.selectedControlColour.cgColor
        textField.layer.borderColor = borderColour
    }
    
}
