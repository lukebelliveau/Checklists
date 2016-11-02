//
//  Checklist.swift
//  Checklists
//
//  Created by Luke on 10/25/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation

class Checklist: NSObject, NSCoding, Entry {
    var text = "";
    var items = [ChecklistItem]();
    
    override init() {
        super.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String;
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem];
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text");
        aCoder.encode(items, forKey: "Items");
    }
}
