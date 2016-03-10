//
//  Product.swift
//  Askit
//
//  Created by Dx on 29/02/16.
//  Copyright © 2016 Palmera. All rights reserved.
//

import Foundation
import CoreData

@objc(Product)

class Product: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var quantity: NSNumber
    @NSManaged var checked: Bool
    @NSManaged var unity: String
    
    struct Keys {
        static let shoppingList: String = "shoppingList"
        static let name: String = "name"
        static let quantity: String = "quantity"
        static let unity: String = "unity"
        static let checked: String = "checked"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Product", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
           
        name = dictionary[Keys.name] as! String
        if dictionary[Keys.quantity] != nil {
            self.quantity = Int(dictionary[Keys.quantity] as! NSNumber)
        } else {
            self.quantity = 1
        }
        
        if dictionary[Keys.unity] != nil {
            self.unity = dictionary[Keys.unity] as! String
        } else {
            self.unity = ""
        }
        
        if dictionary[Keys.checked] != nil{
            self.checked = dictionary[Keys.checked] as! Bool
        } else {
            self.checked = false
        }
    }
}