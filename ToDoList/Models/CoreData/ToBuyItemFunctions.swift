//
//  ToBuyCoreDataFunctions.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-28.
//

import Foundation


class ToBuyItemFunctions {
    
    static let instance = ToBuyItemFunctions()

    var toBuyItems: [ToBuyItem]? {
        return CoreDataFunctions.instance.toBuyItems
    }
    
    private init() {}

    
    func addToBuyItem(itemName: String, isHighPriority: Bool) -> Bool {
        CoreDataFunctions.instance.addToBuyItem(itemName: itemName, isHighPriority: isHighPriority)
    }
    
    
    func deleteToBuyItem(_ item: ToBuyItem) -> Bool {
        CoreDataFunctions.instance.deleteToBuyItems([item])
    }
    
    
    func clearToBuyItems() -> Bool {
        guard let items = toBuyItems else {
            print("Error: delete all to buy items failed, could not fetch to buy items")
            return false
        }
        return CoreDataFunctions.instance.deleteToBuyItems(items)
    }
}
