//
//  DetailViewControllerDelegate.swift
//  Checklists
//
//  Created by Luke on 10/28/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation
import UIKit

class DetailViewControllerDelegate: UITableViewController {
    
    var entryType = NSObject.self
    
    func DetailViewControllerDidCancel(_ controller: DetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func arrayCount() -> Int {
        fatalError("Must override arrayCount")
    }
    
    func append(_ entry : Entry) {
        fatalError("Must override arrayItem")
    }
    
    func saveChecklists() {
        fatalError("Must override saveChecklists");
    }
    
    func getIndex(of: Entry) -> Int? {
        fatalError("Must override getIndexOf");
    }
    
    func configureTextForCell(_ cell: UITableViewCell, withEntry entry: Entry) {
        fatalError("Must override configureTextForCellWithChecklistItem");
    }
    
    func DetailViewController(_ controller: DetailViewController, didFinishAddingItemWithText text: String) {
        
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        print("type: \(entryType)");
        
        guard let item = entryType.init() as? Entry else { return };
        
        item.text = text;
        
        let newRowIndex = arrayCount()
        append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        saveChecklists();
    }
    
    func DetailViewController(_ controller: DetailViewController, didFinishEditingEntry entry: Entry) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
//        guard let entry = entry as? entryType else { return }
        if let index = getIndex(of: entry) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell, withEntry: entry)
            }
        }
        
        saveChecklists();
        
    }
}
