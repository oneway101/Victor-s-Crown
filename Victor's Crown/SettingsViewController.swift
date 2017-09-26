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
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var txtDatePicker: UITextField!
    
    let datePicker = UIDatePicker()
    var startDate = Date()
    
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
        
        daysStepper.value = Double(setDaysGoal)
        readingStepper.value = Double(setReadingGoal)
        prayerStepper.value = Double(setPrayerTimeGoal)
        
        numberOfDaysLabel.text = String(setDaysGoal)
        readingGoalLabel.text = String(setReadingGoal)
        prayerGoalLabel.text = String(setPrayerTimeGoal)
        
        showDatePicker()
        setStartDate = defaults.object(forKey: Constants.UserDefaults.StartDate) as? Date
        txtDatePicker.text = setStartDate?.timestamp()
        
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
        
        startDate = datePicker.date
        
        defaults.set(setDaysGoal, forKey: "daysGoal")
        defaults.set(startDate, forKey: "startDate")
        defaults.set(getFutureDate(setDaysGoal, startDate), forKey: "endDate")
        defaults.set(setReadingGoal, forKey: "readingGoal")
        defaults.set(setPrayerTimeGoal, forKey: "prayerTimeGoal")
        
        performUIUpdatesOnMain {
            self.displayAlert(title: "Settings Saved", message: "Successfully saved your changes.")
            debugPrint("saved settings")
        }
        
    }
    
    
    
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: "donedatePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: "cancelDatePicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtDatePicker.inputAccessoryView = toolbar
        // add datepicker to textField
        txtDatePicker.inputView = datePicker
        
    }
    
    func donedatePicker(){
        txtDatePicker.text = datePicker.date.timestamp()
        startDate = datePicker.date
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    

}
