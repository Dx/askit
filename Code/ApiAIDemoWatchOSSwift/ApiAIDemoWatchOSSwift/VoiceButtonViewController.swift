//
//  VoiceButtonViewController.swift
//  Askit
//
//  Created by Dx on 26/03/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit
import ApiAI
import MBProgressHUD
import WatchConnectivity

class VoiceButtonViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet var voiceRequestButton: AIVoiceRequestButton? = nil
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var buttonView: UIImageView!
    var session: WCSession!
    
    var screenWidth : CGFloat = 0.0
    var screenHeight : CGFloat = 0.0
    
    // MARK: - Actions
    
    override func viewDidLoad() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        self.prefersStatusBarHidden()
        self.setNeedsStatusBarAppearanceUpdate()
        
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
        
        self.voiceRequestButton?.successCallback = {(AnyObject response) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.buttonView.hidden = true
            }
            
            let interpreter = ApiAIResultInterpreter()
            
            self.showAlert(interpreter.showResult(response), title: "Ask it")
            
            dispatch_async(dispatch_get_main_queue()) {
                self.buttonView.hidden = false
                if let results = response["result"] as? [String: AnyObject] {
                    self.searchText.text = results["resolvedQuery"] as? String
                }
            }
        }
        
        self.voiceRequestButton?.failureCallback = {(NSError error) -> Void in
            self.showAlert("Error in callback", title: "Error")
        }
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        searchText.inputAccessoryView=doneToolbar
    }
    
    func doneButtonAction() {
        MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        
        self.searchText?.resignFirstResponder()
        
        let request = ApiAI.sharedApiAI().textRequest()
        
        if let text = self.searchText?.text {
            request.query = [text]
        } else {
            request.query = [""]
        }
        
        request.setCompletionBlockSuccess({[unowned self] (AIRequest request, AnyObject response) -> Void in
            
            let interpreter = ApiAIResultInterpreter()
            self.showAlert(interpreter.showResult(response), title: "Ask it")
            
            MBProgressHUD.hideAllHUDsForView(self.view.window, animated: true)
            }, failure: { (AIRequest request, NSError error) -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view.window, animated: true)
        });
        
        ApiAI.sharedApiAI().enqueue(request)
    }
    
    func showAlert(error:String, title: String) {
        let myAlert = UIAlertController(title: title, message: error, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        myAlert.addAction(OKAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    // MARK: - Session
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        var result = ""
                
        let cdFunctions = CoreDataFunctions()
        if let dict = message["message"] as? [String : AnyObject] {
            cdFunctions.addProduct(dict)
        
            result = "Producto agregado \(dict["name"])"
        } else {
            result = "Error on phone"
        }
        replyHandler(["result": result])
    }
}
