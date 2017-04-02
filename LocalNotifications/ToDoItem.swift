//
//  ToDoItem.swift
//  LocalNotifications
//
//  Created by James Honeyball on 02/04/2017.
//  Copyright © 2017 James Honeyball. All rights reserved.
//

import Foundation

struct ToDoItem {
    var title: String
    var deadline: Date
    var UUID: String

    var isOverdue: Bool {
        return (Date().compare(self.deadline) == ComparisonResult.orderedDescending)
    }
    
    init (deadline: Date, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    


}
