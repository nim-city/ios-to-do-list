//
//  ItemDelegate.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-07-11.
//

import Foundation


protocol ListItem: AnyObject { }


extension ToDoItem: ListItem { }


extension ToBuyItem: ListItem { }
