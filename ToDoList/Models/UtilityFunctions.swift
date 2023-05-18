//
//  UtilityFunctions.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-04-03.
//

import Foundation

class Localization {
    
    enum Keys: String {
        case yes
        case no
        case cancel
        case delete
        
        // Pop ups
        case clearTodaysAgendaText = "pop_up_text_clear_todays_agenda"
        case clearToDoItemsText = "pop_up_text_clear_to_do_items"
        case clearToBuyItemsText = "pop_up_text_clear_to_buy_items"
        case removeItemText = "pop_up_text_remove_item"
        
        // Titles
        case todaysAgendaTitle = "title_todays_agenda"
        case toDoListTitle = "title_to_do_list"
        case toBuyListTitle = "title_to_buy_list"
        case highPriorityTitle = "section_title_high_priority"
        case lowPriorityTitle = "section_title_low_priority"
        case shortTermTitle = "section_title_short_term"
        case longTermTitle = "section_title_long_term"
        case newToDoItemTitle = "title_new_to_do_item"
        case newToBuyItemTitle = "title_new_to_buy_item"
        
    }
    
    private init() {}

    static func getStringForKey(_ key: Keys) -> String {
        NSLocalizedString(key.rawValue, comment: "")
    }
    
}

class StringUtilityFunctions {
    
    private init() {}
    
    static func getTitleForItemListMode(_ itemListMode: ItemListMode) -> String {
        switch itemListMode {
        case .todaysAgenda:
            return Localization.getStringForKey(.todaysAgendaTitle)
        case .toDoItems:
            return Localization.getStringForKey(.toDoListTitle)
        case .toBuyItems:
            return Localization.getStringForKey(.toBuyListTitle)
        }
    }
    
    static func getClearItemsPopUpText(_ itemListMode: ItemListMode) -> String {
        switch itemListMode {
        case .todaysAgenda:
            return Localization.getStringForKey(.clearTodaysAgendaText)
        case .toDoItems:
            return Localization.getStringForKey(.clearToDoItemsText)
        case .toBuyItems:
            return Localization.getStringForKey(.clearToBuyItemsText)
        }
    }
    
}
