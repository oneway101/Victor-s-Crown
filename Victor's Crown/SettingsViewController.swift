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
    
    //Goal Term Setting
    @IBOutlet weak var goalTermLabel: UILabel!
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var daysStepper: UIStepper!
    
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
    
    //let defaultGoalTermDays = "7"
    //let defaultReadingGoal = "1"
    //let defaultPrayerTimeGoal = "5"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookDownloadButton.isEnabled = false
        
        //stepper setting
        //readingStepper.minimumValue = 1
        //prayerStepper.minimumValue = 5
        
        let defaults = UserDefaults.standard
        if let daysGoal = defaults.string(forKey: "daysGoal"), let readingGoal = defaults.string(forKey: "readingGoal"), let prayerTimeGoal = defaults.string(forKey: "prayerTimeGoal"){
            
            numberOfDaysLabel.text = daysGoal
            readingGoalLabel.text = readingGoal
            prayerGoalLabel.text = prayerTimeGoal
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func downloadEntireBook(_ sender: Any) {
        //Create a dictionary to download all scriputures at once.
    }
    
    @IBAction func setGoalTerm(_ sender: UIStepper) {
        let defaults = UserDefaults.standard
        let daysGoal = Int(sender.value)
        numberOfDaysLabel.text = daysGoal.description
        //Q: Where to save the user setting?
        defaults.set(daysGoal, forKey: "daysGoal")
        defaults.set(Date(), forKey: "startDate")
        defaults.set(getFutureDate(daysGoal), forKey: "endDate")
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
