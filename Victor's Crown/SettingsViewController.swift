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
    
    //User Defaults
    let defaults = UserDefaults.standard
    var setStartDate:Date?
    var setEndDate:Date?
    var setDaysGoal:Int = 0
    var setReadingGoal:Int = 0
    var setPrayerTimeGoal:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookDownloadButton.isEnabled = false
        daysStepper.minimumValue = 1
        readingStepper.minimumValue = 1
        prayerStepper.minimumValue = 5
        
        setDaysGoal = defaults.integer(forKey: Constants.UserDefaults.DaysGoal)
        setReadingGoal = defaults.integer(forKey: Constants.UserDefaults.ReadingGoal)
        setPrayerTimeGoal = defaults.integer(forKey: Constants.UserDefaults.PrayerTimeGoal)
        
        numberOfDaysLabel.text = String(setDaysGoal)
        readingGoalLabel.text = String(setReadingGoal)
        prayerGoalLabel.text = String(setPrayerTimeGoal)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func downloadEntireBook(_ sender: Any) {
        //Create a dictionary to download all scriputures at once.
    }
    
    @IBAction func setGoalTerm(_ sender: UIStepper) {
        setDaysGoal = Int(sender.value)
        numberOfDaysLabel.text = setDaysGoal.description
        
    }
    
    @IBAction func setReadingGoal(_ sender: UIStepper) {
        setReadingGoal = Int(sender.value)
        readingGoalLabel.text = setReadingGoal.description
        
    }
    
    @IBAction func setPrayerTimeGoal(_ sender: UIStepper) {
        setPrayerTimeGoal = Int(sender.value)
        prayerGoalLabel.text = setPrayerTimeGoal.description
        
    }
  
    @IBAction func saveSettings(_ sender: Any){
        
        defaults.set(setDaysGoal, forKey: "daysGoal")
        defaults.set(Date(), forKey: "startDate")
        defaults.set(getFutureDate(setDaysGoal), forKey: "endDate")
        defaults.set(setReadingGoal, forKey: "readingGoal")
        defaults.set(setPrayerTimeGoal, forKey: "prayerTimeGoal")
        
        performUIUpdatesOnMain {
            self.displayAlert(title: "Settings Saved", message: "Successfully saved your changes.")
            debugPrint("saved settings")
        }
        
    }
    

}
