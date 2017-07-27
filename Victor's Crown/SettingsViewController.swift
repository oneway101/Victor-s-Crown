//
//  SettingsViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/24/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var readBibleOfflineLabel: UILabel!
    @IBOutlet weak var bookDownloadButton: UIButton!
    
    //Scripture Reading Setting
    @IBOutlet weak var scriptureReadingLabel: UILabel!
    @IBOutlet weak var readingGoalLabel: UILabel!
    @IBOutlet weak var chaptersLabel: UILabel!
    @IBOutlet weak var readingStepper: UIStepper!
    
    //Prayer Time Setting
    @IBOutlet weak var prayerTimeLabel: UILabel!
    @IBOutlet weak var prayerGoalLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var prayerStepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookDownloadButton.isEnabled = false
        //stepper setting
        //readingStepper.minimumValue = 1
        //prayerStepper.minimumValue = 5
        
        let defaults = UserDefaults.standard
        if let readingGoal = defaults.string(forKey: "readingGoal"){
            readingGoalLabel.text = readingGoal
        }
        if let prayerGoal = defaults.string(forKey: "prayerTimeGoal"){
            prayerGoalLabel.text = prayerGoal
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func downloadEntireBook(_ sender: Any) {
        //Create a dictionary to download all scriputures at once.
    }
    
    @IBAction func setReadingGoal(_ sender: UIStepper) {
        let defaults = UserDefaults.standard
        let readingGoal = Int(sender.value)
        readingGoalLabel.text = readingGoal.description
        //Q: Where to save the user setting?
        defaults.set(readingGoal, forKey: "readingGoal")
    }
    
    @IBAction func setPrayerTimeGoal(_ sender: UIStepper) {
        let defaults = UserDefaults.standard
        let prayerTimeGoal = Int(sender.value)
        prayerGoalLabel.text = prayerTimeGoal.description
        defaults.set(prayerTimeGoal, forKey: "prayerTimeGoal")
    }
    
    

}
