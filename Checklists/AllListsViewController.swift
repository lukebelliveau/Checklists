//
//  AllListsTableViewController.swift
//  checklists
//
//  Created by Luke on 10/25/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, DetailViewControllerDelegate {
    
    var checklists: [Checklist];

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        checklists = [Checklist]();
        
        super.init(coder: aDecoder);
        
        var list = Checklist();
        list.text = "Birthdays";
        checklists.append(list);
        
        list = Checklist();
        list.text = "List2";
        checklists.append(list);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "EditChecklist" {
            let navigationController = segue.destination as! UINavigationController;
            let controller = navigationController.topViewController as! ListEntryDetailViewController;
            controller.delegate = self;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView: tableView);
        
        let checklist = checklists[indexPath.row];
        cell.textLabel!.text = "List \(checklist.text)";
        cell.accessoryType = .detailDisclosureButton;
        return cell;
    }
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell";
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell;
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier);
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        checklists.remove(at: (indexPath as NSIndexPath).row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
//        dataService.save(checklistItems: items);
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = checklists[indexPath.row];
        print ("didSelectRow: " + checklist.text);
        performSegue(withIdentifier: "ShowChecklist", sender: checklist);
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "DetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListEntryDetailViewController;
        
        controller.delegate = self;
        
        let checklist = checklists[indexPath.row];
        controller.entryToEdit = checklist;
        
        present(navigationController, animated: true, completion: nil);
    }
    
    func ListEntryDetailViewControllerDidCancel(_ controller: ListEntryDetailViewController) {
        dismiss(animated: true, completion: nil);
    }
    
    func ListEntryDetailViewController(_ controller: ListEntryDetailViewController, didFinishAddingItemWithText text: String) {
        let checklist = Checklist();
        checklist.text = text;
        
        let newRowIndex = checklists.count
        checklists.append(checklist);
        
        let indexPath = IndexPath(row: newRowIndex, section: 0);
        let indexPaths = [indexPath];
        tableView.insertRows(at: indexPaths, with: .automatic);
        
        dismiss(animated: true, completion: nil);
    }
    
    func ListEntryDetailViewController(_ controller: ListEntryDetailViewController, didFinishEditingEntry entry: Entry) {
        let checklist = entry as! Checklist;
        if let index = checklists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0);
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell, withEntry: checklist);
            }
        }
        
        dismiss(animated: true, completion: nil);
    }
    
    func configureTextForCell(_ cell: UITableViewCell, withEntry entry: Entry){
        let label = cell.textLabel
//        let label = cell.viewWithTag(1000) as! UILabel
        label?.text = entry.text
    }
}
