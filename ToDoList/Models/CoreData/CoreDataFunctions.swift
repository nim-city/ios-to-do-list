//
//  CoreDataFunctions.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-03-09.
//

import CoreData
import UIKit


class CoreDataFunctions {

    
    static let instance = CoreDataFunctions()
    
    private var managedObjectContext: NSManagedObjectContext? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }
    
    var toDoItems: [ToDoItem]?
    var toBuyItems: [ToBuyItem]?
    
    
    private init() {
        toDoItems = getAllToDoItems()
        toBuyItems = getAllToBuyItems()
    }
    
    
    // Get
    
    func getAllToDoItems() -> [ToDoItem]? {
        guard let context = managedObjectContext else {
            print("Error: to buy items fetch failed, managed object context is nil")
            return nil
        }
        do {
            return try context.fetch(ToDoItem.fetchRequest())
        } catch let error {
            print("Error, to buy items fetch failed, \(error)")
            return nil
        }
    }
    
    
    func getAllToBuyItems() -> [ToBuyItem]? {
        guard let context = managedObjectContext else {
            print("Error: to buy items fetch failed, managed object context is nil")
            return nil
        }
        do {
            return try context.fetch(ToBuyItem.fetchRequest())
        } catch let error {
            print("Error, to buy items fetch failed, \(error)")
            return nil
        }
    }
    
    
    // Add
    
    func addToDoItem(itemName: String, isHighPriority: Bool, isLongTerm: Bool) -> Bool {
        guard let context = managedObjectContext else {
            print("Error: add item failed, managed object context is nil")
            return false
        }
        let toDoItem = ToDoItem(entity: ToDoItem.entity(), insertInto: context)
        toDoItem.name = itemName
        toDoItem.isHighPriority = isHighPriority
        toDoItem.isLongTerm = isLongTerm
        return saveContext(shouldReloadToDoItems: true)
    }
    
    
    func addToBuyItem(itemName: String, isHighPriority: Bool) -> Bool {
        guard let context = managedObjectContext else {
            print("Error: add item failed, managed object context is nil")
            return false
        }
        let toBuyItem = ToBuyItem(entity: ToBuyItem.entity(), insertInto: context)
        toBuyItem.name = itemName
        toBuyItem.isHighPriority = isHighPriority
        return saveContext(shouldReloadToBuyItems: true)
    }
    
    
    // Delete
    
    func deleteToDoItems(_ items: [ToDoItem]) -> Bool {
        guard let context = managedObjectContext else {
            print("Error: delete to do items failed, managed object context is nil")
            return false
        }
        for item in items {
            context.delete(item)
        }
        return saveContext(shouldReloadToDoItems: true)
    }
    
    
    func deleteToBuyItems(_ items: [ToBuyItem]) -> Bool {
        guard let context = managedObjectContext else {
            print("Error: delete to buy items failed, managed object context is nil")
            return false
        }
        for item in items {
            context.delete(item)
        }
        return saveContext(shouldReloadToBuyItems: true)
    }
    
    
    // Update
    
    func selectToDoItems(_ toDoItems: [ToDoItem]) -> Bool {
        for item in toDoItems {
            item.isOnAgenda = true
        }
        return saveContext(shouldReloadToDoItems: true)
    }
    
    
    func unselectToDoItems(_ toDoItems: [ToDoItem]) -> Bool {
        for item in toDoItems {
            item.isOnAgenda = false
        }
        return saveContext(shouldReloadToDoItems: true)
    }
    
    
    // Save
    
    private func saveContext(shouldReloadToDoItems: Bool = false, shouldReloadToBuyItems: Bool = false) -> Bool {
        do {
            try managedObjectContext?.save()
            if shouldReloadToDoItems {
                toDoItems = getAllToDoItems()
            }
            if shouldReloadToBuyItems {
                toBuyItems = getAllToBuyItems()
            }
            print("Core Data Functions save succeeded")
            return true
        } catch let error {
            print("Error: Core Data Functions save failed, \(error)")
            return false
        }
    }
}
