//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Luke on 9/23/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}