//
//  TodaysAgendaCoreDataFunctions.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-04-09.
//

import Foundation


class TodaysAgendaFunctions {
    
    static let instance = TodaysAgendaFunctions()
    
    var todaysAgenda: [ToDoItem]? {
        return CoreDataFunctions.instance.toDoItems?.filter({ $0.isOnAgenda })
    }
    
    
    private init() {}

    
    func selectItems(_ items: [ToDoItem]) -> Bool {
        CoreDataFunctions.instance.selectToDoItems(items)
    }
    
    
    func unselectItem(_ item: ToDoItem) -> Bool {
        CoreDataFunctions.instance.unselectToDoItems([item])
    }
    
    
    func clearTodaysAgenda() -> Bool {
        guard let items = todaysAgenda else {
            print("Error: clear todays agenda failed, could not fetch to do items")
            return false
        }
        return CoreDataFunctions.instance.unselectToDoItems(items)
    }
}
