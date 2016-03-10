//
//  ShoppingList.swift
//  ApiAIDemoWatchOSSwift
//
//  Created by Dx on 29/02/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

import Foundation
import CoreData

@objc(ShoppingList)

class ShoppingList: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var products: [Product]
    
    struct Keys {
        static let name: String = "name"
        static let products = "products"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("ShoppingList", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = dictionary[Keys.name] as! String
//        products = dictionary[Keys.products] as! [Product]
    }
}