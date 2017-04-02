//
//  TodoSchedulingViewController.swift
//  LocalNotifications
//
//  Created by James Honeyball on 02/04/2017.
//  Copyright © 2017 James Honeyball. All rights reserved.
//

import UIKit

class TodoSchedulingViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var deadlinePicker: UIDatePicker!


    @IBAction func resignKeyboard(_ sender: Any) {
        view.endEditing(true)
    }


    @IBAction func savePressed(_ sender: UIButton) {
        let toDoItem = ToDoItem(deadline: deadlinePicker.date, title: titleField.text!, UUID: UUID().uuidString)
        ToDoList.sharedInstance.addItem(toDoItem) // schedule a local notification to persist this item
        let _ = self.navigationController?.popToRootViewController(animated: true) // return to list view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TodoSchedulingViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
