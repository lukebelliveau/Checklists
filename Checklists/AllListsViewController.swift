//
//  AllListsTableViewController.swift
//  checklists
//
//  Created by Luke on 10/25/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class AllListsViewController: DetailViewControllerDelegate {
    
    var checklists: [Checklist];
    let dataService: DataService;

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dataService = DataService();
        checklists = dataService.loadChecklists()
        
        super.init(coder: aDecoder);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            
            controller.checklist = sender as! Checklist
            controller.listVC = self;
        } else if segue.identifier == "EditChecklist" {
            let navigationController = segue.destination as! UINavigationController;
            let controller = navigationController.topViewController as! DetailViewController;
            controller.delegate = self;
        }
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
        
        saveChecklists();
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = checklists[indexPath.row];
        performSegue(withIdentifier: "ShowChecklist", sender: checklist);
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "DetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! DetailViewController;
        
        controller.delegate = self;
        
        let checklist = checklists[indexPath.row];
        controller.entryToEdit = checklist;
        
        present(navigationController, animated: true, completion: nil);
    }
    
    override func DetailViewController(_ controller: DetailViewController, didFinishAddingItemWithText text: String) {
        let checklist = Checklist();
        checklist.text = text;
        
        let newRowIndex = checklists.count
        checklists.append(checklist);
        
        let indexPath = IndexPath(row: newRowIndex, section: 0);
        let indexPaths = [indexPath];
        tableView.insertRows(at: indexPaths, with: .automatic);
        
        saveChecklists();
        dismiss(animated: true, completion: nil);
    }
    
    override func DetailViewController(_ controller: DetailViewController, didFinishEditingEntry entry: Entry) {
        let checklist = entry as! Checklist;
        if let index = checklists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0);
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell, withEntry: checklist);
            }
        }
        saveChecklists();
        dismiss(animated: true, completion: nil);
    }
    
    func configureTextForCell(_ cell: UITableViewCell, withEntry entry: Entry){
        let label = cell.textLabel
        label?.text = entry.text
    }
    
    func saveChecklists() {
        dataService.save(checklists);
    }
}
