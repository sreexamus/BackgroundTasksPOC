//
//  ViewController.swift
//  BackgroundTasksPOC
//
//  Created by iragam reddy, sreekanth reddy on 11/22/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flagUpdate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let isProcess = "isProcessingTask \(UserDefaults.standard.string(forKey: "isProcessingTask") ?? "")"
        let isAppRef = "isAppRefreshTask  \(UserDefaults.standard.string(forKey: "isAppRefreshTask") ?? "")"
        flagUpdate.text = isProcess + isAppRef
    }

    @IBAction func shoLatestData(_ sender: Any) {
        let isProcess = "isProcessingTask \(UserDefaults.standard.string(forKey: "isProcessingTask") ?? "")"
        let isAppRef = "isAppRefreshTask  \(UserDefaults.standard.string(forKey: "isAppRefreshTask") ?? "")"
        flagUpdate.text = isProcess + isAppRef
    }
}

