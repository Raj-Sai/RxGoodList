//
//  TaskListViewController.swift
//  RxGoodList
//
//  Created by Amsaraj Mariyappan on 19/6/2565 BE.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTask: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        Observable.of(2,4,6,8)
            .toArray()
            .subscribe({ [weak self] task in
                print(task)
            }).disposed(by: disposeBag)
        
        Observable.of(4,5,6)
            .map {
                return ($0 * 2)
            }
            .map {
                return String($0)
            }
            .toArray()
            .subscribe({
                print($0)
            }).disposed(by: disposeBag)
        
        let student1 = Student(score: BehaviorRelay(value: 45))
        
        let student = PublishSubject<Student>()
        student.asObserver()
            .flatMap { $0.score.asObservable() }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        student.onNext(student1)
        student1.score.accept(75)

    }
    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        cell.textLabel?.text = filteredTask[indexPath.row].title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addTVC = navC.viewControllers.first as? AddTaskViewController else {
            return
        }
        addTVC.taskSubjectObserver
            .subscribe(onNext: { [weak self] task in
                guard let self = self else { return }
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                var tasks = self.tasks.value
                tasks.append(task)
                self.tasks.accept(tasks)
                self.filterTask(priority: priority)
            }).disposed(by: disposeBag)
    }
    
    private func filterTask(priority: Priority?) {
        if priority == nil {
            self.filteredTask = self.tasks.value
        } else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority}
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTask = tasks
                print(tasks)
            }).disposed(by: disposeBag)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func priorityValueChnage(segmentControl: UISegmentedControl) {
        let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex - 1)
        filterTask(priority: priority)
    }
    
    
}

struct Student {
    var score: BehaviorRelay<Int>
}
