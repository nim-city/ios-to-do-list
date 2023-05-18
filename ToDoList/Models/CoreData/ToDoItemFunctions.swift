//
//  CoreDataFunctions.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-21.
//

import Foundation


class ToDoItemFunctions {
    
    static let instance = ToDoItemFunctions()
    
    var toDoItems: [ToDoItem]? {
        return CoreDataFunctions.instance.toDoItems
    }
    
    
    private init() {}

    
    func addToDoItem(itemName: String, isHighPriority: Bool, isLongTerm: Bool) -> Bool {
        CoreDataFunctions.instance.addToDoItem(itemName: itemName, isHighPriority: isHighPriority, isLongTerm: isLongTerm)
    }
    
    
    func deleteToDoItem(_ item: ToDoItem) -> Bool {
        CoreDataFunctions.instance.deleteToDoItems([item])
    }
    
    
    func clearToDoItems() -> Bool {
        guard let items = toDoItems else {
            print("Error: delete all to do items failed, could not fetch to do items")
            return false
        }
        return CoreDataFunctions.instance.deleteToDoItems(items)
    }
}
