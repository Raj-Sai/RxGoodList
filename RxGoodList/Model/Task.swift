//
//  Task.swift
//  RxGoodList
//
//  Created by Amsaraj Mariyappan on 19/6/2565 BE.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
