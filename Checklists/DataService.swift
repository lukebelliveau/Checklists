//
//  DataService.swift
//  Checklists
//
//  Created by Luke on 10/24/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation

class DataService {
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).appendingPathComponent("Checklists.plist")
    }
    
    func save(checklistItems items: [ChecklistItem]) {
        let data = NSMutableData();
        let archiver = NSKeyedArchiver(forWritingWith: data);
        archiver.encode(items, forKey: "checklistItems");
        
        archiver.finishEncoding();
        data.write(toFile:dataFilePath(), atomically: true);
        
    }
    
    func loadChecklistItems() -> [ChecklistItem] {
        let path = dataFilePath();
        var items = [ChecklistItem]();
        
        if FileManager.default.fileExists(atPath: path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data);
                items = unarchiver.decodeObject(forKey: "checklistItems") as! [ChecklistItem];
                
                unarchiver.finishDecoding();
            }
        }
        
        return items
   
    }
    
}
