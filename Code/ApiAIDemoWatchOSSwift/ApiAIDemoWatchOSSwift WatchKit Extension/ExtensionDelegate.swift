//
//  ExtensionDelegate.swift
//  ApiAIDemoWatchOSSwift WatchKit Extension
//
//  Created by Dx on 21/10/15.
//  Copyright © 2015 Palmera. All rights reserved.
//

import WatchKit
import Foundation
import ApiAI

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        let configuration = AIDefaultConfiguration()
        
        configuration.clientAccessToken = "4b0fe7886274402481279dc53c2e1006"
        configuration.subscriptionKey = "d835f1ea-dd79-480d-9522-e3579cac3f2d"
        
        ApiAI.sharedApiAI().configuration = configuration
        
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
