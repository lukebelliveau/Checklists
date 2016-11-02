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
    
    func DetailViewControllerDidCancel(_ controller: DetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func DetailViewController(_ controller: DetailViewController, didFinishAddingItemWithText text: String) {
        
    }
    
    func DetailViewController(_ controller: DetailViewController, didFinishEditingEntry entry: Entry) {
        
    }
}
