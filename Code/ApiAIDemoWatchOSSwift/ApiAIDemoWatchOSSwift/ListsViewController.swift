//
//  ListsViewController.swift
//  Askit
//
//  Created by Dx on 01/03/16.
//  Copyright © 2016 Palmera. All rights reserved.
//

import UIKit
import CoreData

class ListsViewController: UITableViewController, TableViewCellDelegate {

    var products: [Product] = []
    
    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = 50
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.prefersStatusBarHidden()
    }
    
    override func viewWillAppear(animated: Bool) {
        let cdFunctions = CoreDataFunctions()
        products = cdFunctions.fetchProducts()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Shared Context
    
    lazy var sharedContext: NSManagedObjectContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        cell.selectionStyle = .None
        
        if let product = products[indexPath.row] as Product! {
            cell.toDoItem = product
        }
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    // MARK: - TableViewCellDelegate Delegate
    
    func toDoItemChecked(toDoItem: Product) {
        toDoItem.checked = !toDoItem.checked
        
        CoreDataStackManager.sharedInstance().saveContext()
        tableView.reloadData()
    }
    
    func toDoItemDeleted(toDoItem: Product) {
        let index = (products as NSArray).indexOfObject(toDoItem)
        if index == NSNotFound { return }
        
        products.removeAtIndex(index)
        sharedContext.deleteObject(toDoItem as NSManagedObject)
        
        // loop over the visible cells to animate delete
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as TableViewCell
        var delay = 0.0
        var startAnimating = false
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if startAnimating {
                UIView.animateWithDuration(0.3, delay: delay, options: .CurveEaseInOut,
                    animations: {() in
                        cell.frame = CGRectOffset(cell.frame, 0.0,
                            -cell.frame.size.height)},
                    completion: {(finished: Bool) in
                        if (cell == lastView) {
                            self.tableView.reloadData()
                        }
                    }
                )
                delay += 0.03
            }
            if cell.toDoItem === toDoItem {
                startAnimating = true
                cell.hidden = true
            }
        }

        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
        
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    // MARK: - Utils
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = products.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
}
