//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Luke on 9/23/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    override init() {
        super.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String;
        checked = aDecoder.decodeBool(forKey: "Checked");
        super.init();
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text");
        aCoder.encode(checked, forKey: "Checked");
    }
}
