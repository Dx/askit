//
//  ApiAIResultInterpreter.swift
//  Askit
//
//  Created by Dx on 02/03/16.
//  Copyright © 2016 Palmera. All rights reserved.
//

import Foundation

class ApiAIResultInterpreter {
    
    // MARK: - Methods
    
    func showResult(response: AnyObject) -> String {
        
        var textResult = ""
        let status = response["status"]!
        let code = status!["code"] as? Int
        
        if (code != 200) {
            return "Could not recognize"
        }
        
        if let results = response["result"] as? [String: AnyObject] {
            if let fulfillment = results["fulfillment"] as? [String: AnyObject] {
                if let speech = fulfillment["speech"] as? String {
                    textResult = speech
                }
            } else {
                if let speech = results["speech"] as? String {
                    textResult = speech
                }
            }
                
            let resolvedQuery = results["resolvedQuery"] as? String
            
            
            var dict = [String: AnyObject]()
            
            if let parameters = results["parameters"] {
                if let producto = parameters["producto"]!!["producto"] as? String {
                    dict[Product.Keys.name] = producto
                    
                    if let unidad = parameters["unidad"]!!["unidad"] as? String {
                        dict[Product.Keys.unity] = unidad
                        
                        if let number = parameters["cantidad"]!!["cantidad"] as? String {
                            if let numberCasted = Int(number) {
                                dict[Product.Keys.quantity] = numberCasted
                            } else {
                                dict[Product.Keys.quantity] = 0
                            }
                        }
                    }
                }
            } else {
                return "Could not recognize \(resolvedQuery)"
            }
            
            if dict[Product.Keys.name] != nil {
                
                let cdFunctions = CoreDataFunctions()
                cdFunctions.addProduct(dict)
            }
        }
        
        return textResult
    }
}