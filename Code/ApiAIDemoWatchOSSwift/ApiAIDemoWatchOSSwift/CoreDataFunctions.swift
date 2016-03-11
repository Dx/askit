//
//  CoreDataFunctions.swift
//  Askit
//
//  Created by Dx on 08/03/16.
//  Copyright © 2016 Palmera. All rights reserved.
//

import Foundation
import CoreData

class CoreDataFunctions {
    
    // MARK: - Shared Context
    
    lazy var sharedContext: NSManagedObjectContext = {
        CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    // MARK: - Methods
    
    func existsProduct(productName: String) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "name = %@", productName)
        
        let results: [AnyObject]?
        
        do {
            results = try sharedContext.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)", terminator: "")
            abort()
        }
        
        if let products = results as? [Product] {
            return products.count > 0
        } else {
            return false
        }
    }
    
    func fetchProducts() -> [Product] {
        
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let results: [AnyObject]?
        
        do {
            results = try sharedContext.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)", terminator: "")
            abort()
        }
        
        return results as? [Product] ?? [Product]()
    }
    
    func addProduct(product: [String: AnyObject]) {
        
        if let name = product[Product.Keys.name] as? String {
            let cdFunctions = CoreDataFunctions()
            
            if !cdFunctions.existsProduct(name) {
                _ = Product(dictionary: product, context: sharedContext)
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
}