//
//  LanguageViewController.swift
//  ApiAIDemoWatchOSSwift
//
//  Created by Dx on 10/03/16.
//  Copyright © 2016 Palmera. All rights reserved.
//

import UIKit
import ApiAI

class LanguageViewController: UIViewController {

    @IBOutlet weak var languageOptions: UISegmentedControl!
    
    @IBAction func LanguageSelected(sender: AnyObject) {
        
        let configuration = AIDefaultConfiguration()
        
        switch (languageOptions.selectedSegmentIndex)
        {
        case 0:
            configuration.clientAccessToken = "2c47adb2a8a5435586590e680b461d07"
        case 1:
            configuration.clientAccessToken = "4b0fe7886274402481279dc53c2e1006"
        default:
            configuration.clientAccessToken = "2c47adb2a8a5435586590e680b461d07"
        }

        configuration.subscriptionKey = "d835f1ea-dd79-480d-9522-e3579cac3f2d"
        
        ApiAI.sharedApiAI().configuration = configuration
        
    }
}
