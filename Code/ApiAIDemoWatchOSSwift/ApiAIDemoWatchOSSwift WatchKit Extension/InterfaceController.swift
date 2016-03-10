//
//  InterfaceController.swift
//  ApiAIDemoWatchOSSwift WatchKit Extension
//
//  Created by Dx on 21/10/15.
//  Copyright © 2015 Palmera. All rights reserved.
//

import WatchKit
import Foundation
import ApiAI
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var button: WKInterfaceButton!
    @IBOutlet weak var progressImage: WKInterfaceImage!
    
    var session : WCSession!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    @IBAction func doAction(sender: AnyObject) {
        self.textRequest()
    }
    
    private func textRequest() {
        
        self.presentTextInputControllerWithSuggestions(
            nil,
            allowedInputMode: .Plain) { (results) -> Void in
                guard let results = results as? [String] else {
                    return
                }
                
                guard let text = results.first else {
                    return
                }
                
                self.showProgress()
                
                let api = ApiAI.sharedApiAI()
                
                let request = api.textRequest()
                request.query = text
                
                self.button.setTitle("En reloj \(text)")
                
                request.setMappedCompletionBlockSuccess(
                    { (request, response) -> Void in
                        
                        if let responseCasted = response as? AIResponse {
                            
//                            let speech = responseCasted.result.fulfillment.speech
//                            self.button.setTitle(speech)
                            
                            let interpreter = ApiAIResultInterpreterWatch()
                            
                            let product = interpreter.getProduct(responseCasted)
                        
                            let infoDictionary = ["message" : product]
                            
                            self.button.setTitle("Enviando \(infoDictionary["name"])")
                        
                            self.session.sendMessage(infoDictionary, replyHandler: {(result: [String : AnyObject]) -> Void in
                                
                                if let message = result["message"] as? String {
                                    self.button.setTitle(message)
                                }
                                
                                self.dismissProgress()
                                
                                },  errorHandler: {(error ) -> Void in
                                    self.button.setTitle("Error \(error.code)")
                                    self.dismissProgress()
                            })
                        } else {
                            self.button.setTitle("Error, try again")
                        }
                        
                    }, failure: { (request, error) -> Void in
                        self.dismissProgress()
                    }
                )
                
            api.enqueue(request)
        }
    }
    
    private func showProgress() {
        button.setHidden(true)
        progressImage.setHidden(false)
        progressImage.startAnimating()
    }
    
    private func dismissProgress() {
        button.setHidden(false)
        progressImage.setHidden(true)
        progressImage.stopAnimating()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
