//
//  ProductSerialize.swift
//  ApiAIDemoWatchOSSwift
//
//  Created by Dx on 09/03/16.
//  Copyright © 2016 Palmera. All rights reserved.
//

import Foundation

@objc(ProductSerialize)

class ProductSerialize: NSObject {
    @NSManaged var name: String
    @NSManaged var quantity: NSNumber
    @NSManaged var checked: Bool
    @NSManaged var unity: String
}