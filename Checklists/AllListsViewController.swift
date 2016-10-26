//
//  AllListsTableViewController.swift
//  checklists
//
//  Created by Luke on 10/25/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    var checklists: [Checklist];

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        checklists = [Checklist]();
        
        super.init(coder: aDecoder);
        
        var list = Checklist();
        list.name = "Birthdays";
        checklists.append(list);
        
        list = Checklist();
        list.name = "List2";
        checklists.append(list);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            
            controller.checklist = sender as! Checklist
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
        
        let item = checklists[indexPath.row];
        cell.textLabel!.text = "List \(item.name)";
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = checklists[indexPath.row];
        print ("didSelectRow: " + checklist.name);
        performSegue(withIdentifier: "ShowChecklist", sender: checklist);
    }

}
