//
//  AddTaskViewController.swift
//  RxGoodList
//
//  Created by Amsaraj Mariyappan on 19/6/2565 BE.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextFiled: UITextField!
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObserver: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBAction func save() {
        guard let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex),
              let title = self.taskTitleTextFiled.text else {
                  return
              }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
