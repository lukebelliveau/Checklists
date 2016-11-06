//
//  ViewController.swift
//  Checklists
//
//  Created by Luke on 9/23/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class ChecklistViewController: DetailViewControllerDelegate {
    
    let dataService: DataService;
    var checklist: Checklist!;
    var listVC: AllListsViewController!;
    
    required init?(coder aDecoder: NSCoder) {
        dataService = DataService();
        super.init(coder: aDecoder)
        entryType = ChecklistItem.self
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
                controller.entryToEdit = checklist.items[(indexPath as NSIndexPath).row]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.text;
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    //different because different cell implementations
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[(indexPath as NSIndexPath).row]
        
        configureTextForCell(cell, withEntry: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = checklist.items[(indexPath as NSIndexPath).row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        listVC.saveChecklists()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        checklist.items.remove(at: (indexPath as NSIndexPath).row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        listVC.saveChecklists()
    }
    
    override func arrayCount() -> Int {
        return checklist.items.count
    }
    
    override func append(_ entry: Entry) {
        guard let item = entry as? ChecklistItem else { return }
        checklist.items.append(item)
    }
    
    override func saveChecklists() {
        listVC.saveChecklists()
    }
    
    
    override func getIndex(of entry: Entry) -> Int? {
        guard let entry = entry as? ChecklistItem else { return nil }
        return checklist.items.index(of: entry)
    }
    
    override func configureTextForCell(_ cell: UITableViewCell, withEntry entry: Entry){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = entry.text
    }
    
    func configureCheckmarkForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "☑︎"
        } else {
            label.text = ""
        }
    }
    
}

