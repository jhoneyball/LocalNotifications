//
//  ToDoList.swift
//  LocalNotifications
//
//  Created by James Honeyball on 02/04/2017.
//  Copyright © 2017 James Honeyball. All rights reserved.
//

import UIKit

class ToDoList {
    static let sharedInstance = ToDoList()

    fileprivate let ITEMS_KEY = "todoItems"
    func addItem(_ item: ToDoItem) {
        // persist a representation of this todo item in UserDefaults
        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Todo Item \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline as Date // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    func removeItem(_ item: ToDoItem) {
        let scheduledNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
        guard scheduledNotifications != nil else {return} // Nothing to remove, so return
        
        for notification in scheduledNotifications! { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and cancel the notification that corresponds to this TodoItem instance (matched
                UIApplication.shared.cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                break
            }
        }
        
        if var toDoItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
            toDoItems.removeValue(forKey: item.UUID)
            UserDefaults.standard.set(toDoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
        }
    }
    
    func allItems() -> [ToDoItem] {
        let todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? [:]
        let items = Array(todoDictionary.values)
        return items.map({
            let item = $0 as! [String:AnyObject]
            return ToDoItem(deadline: item["deadline"] as! Date,
                            title: item["title"] as! String,
                            UUID: item["UUID"] as! String!)}).sorted(by: {(left: ToDoItem, right:ToDoItem) -> Bool in
            (left.deadline.compare(right.deadline) == .orderedAscending)
        })
    }
    
}

