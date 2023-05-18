//
//  ItemListSelectionDelegate.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-21.
//

import Foundation


protocol ItemListDelegate: AnyObject {
    
    var itemListMode: ItemListMode { get set }
    
    var todaysAgenda: [ToDoItem] { get }
    
    var toDoItems: [ToDoItem] { get }
    
    var toBuyItems: [ToBuyItem] { get }
    
    func itemListWasChanged() -> Void
}
