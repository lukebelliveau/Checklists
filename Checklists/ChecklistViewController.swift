//
//  ViewController.swift
//  Checklists
//
//  Created by Luke on 9/23/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, DetailViewControllerDelegate {
    
    var items: [ChecklistItem]
    let dataService: DataService;
    var checklist: Checklist!;
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        dataService = DataService();
        super.init(coder: aDecoder)
        items = dataService.loadChecklistItems();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            
            let controller = navigationController.topViewController as! DetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! DetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.entryToEdit = items[(indexPath as NSIndexPath).row]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.text;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[(indexPath as NSIndexPath).row]
        
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = items[(indexPath as NSIndexPath).row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        dataService.save(checklistItems: items);
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        items.remove(at: (indexPath as NSIndexPath).row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        dataService.save(checklistItems: items);
    }
    
    func configureTextForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmarkForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "☑︎"
        } else {
            label.text = ""
        }
    }
    
    func DetailViewControllerDidCancel(_ controller: DetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func DetailViewController(_ controller: DetailViewController, didFinishAddingItemWithText text: String) {
        let item = ChecklistItem();
        item.text = text;
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dataService.save(checklistItems: items);
        
        dismiss(animated: true, completion: nil)
    }
    
    func DetailViewController(_ controller: DetailViewController, didFinishEditingEntry entry: Entry) {
        let item = entry as! ChecklistItem;
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        
        dataService.save(checklistItems: items);
        
        dismiss(animated: true, completion: nil)
    }
    
}

