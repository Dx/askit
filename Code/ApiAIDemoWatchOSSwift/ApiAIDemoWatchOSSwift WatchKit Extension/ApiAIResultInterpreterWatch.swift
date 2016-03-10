//
//  ApiAIResultInterpreter.swift
//  ApiAIDemoWatchOSSwift
//
//  Created by Dx on 09/03/16.
//  Copyright © 2016 Palmera. All rights reserved.
//

import Foundation
import ApiAI

class ApiAIResultInterpreterWatch {
    func getProduct(response: AIResponse) -> ProductSerialize {
        
        var productSerialize = ProductSerialize()
        let status = response.status
        let code = status.code
        
        if (code != 200) {
            return productSerialize
        }
        
        productSerialize.quantity = 1
        productSerialize.unity = ""
        
        if let results = response.result as AIResponseResult! {
            if let parameters = results.parameters {
                if let producto = parameters["producto"]!["producto"] as? String {
                    productSerialize.name = producto
                    
                    if let unidad = parameters["unidad"]!["unidad"] as? String {
                        productSerialize.unity = unidad
                        
                        if let number = parameters["cantidad"]!["cantidad"] as? String {
                            if let numberCasted = Int(number) {
                                productSerialize.quantity = numberCasted
                            }
                        }
                    }
                } else {
                    if let producto = parameters["producto"] as? String {
                        productSerialize.name = producto
                    }
                }
            }
        }
        
        return productSerialize
    }

}