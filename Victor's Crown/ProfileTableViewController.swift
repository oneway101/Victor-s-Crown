//
//  ProfileTableViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/25/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "HistoryCell"

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Mark: Progress View
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var goalTermLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var readingProgressLabel: UILabel!
    @IBOutlet weak var prayingLabel: UILabel!
    @IBOutlet weak var prayingProgressLabel: UILabel!
    
    //Mark: Goals
    var setDaysGoal:Int = 0
    var setReadingGoal:Double = 0.0
    var setPrayerTimeGoal:Double = 0.0
    
    @IBOutlet weak var goalDescriptionText: UILabel!
    
    //Mark: History Table View
    @IBOutlet weak var profileTableView: UITableView!
    
    //var notes:[Note] = [Note]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        
        let context = CoreDataStack.getContext()
        
        do {
            
            DataModel.notes = try context.fetch(fetchRequest)
            print("Successfully fetched \(DataModel.notes.count)  notes. ")
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        performUIUpdatesOnMain {
            self.profileTableView.reloadData()
            print("Reloaded profileTableView data.")
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let daysGoal = defaults.string(forKey: "daysGoal"), let readingGoal = defaults.string(forKey: "readingGoal"), let prayerTimeGoal = defaults.string(forKey: "prayerTimeGoal"){
            
            setDaysGoal = Int(daysGoal)!
            setReadingGoal = Double(readingGoal)!
            setPrayerTimeGoal = Double(prayerTimeGoal)!
            
            goalDescriptionText.text = "Your goal is to read \(readingGoal) chapters \n pray \(prayerTimeGoal) minutes for \(daysGoal) days."
        } else {
            //Set default goal values.
            goalDescriptionText.text = "Your goal is to read 7 chapters \n pray 70 minutes for 7 days."
            defaults.set(7, forKey: "daysGoal")
            defaults.set(7.0, forKey: "readingGoal")
            defaults.set(70.0, forKey: "prayerTimeGoal")
            setDaysGoal = 7
            setReadingGoal = 7.0
            setPrayerTimeGoal = 70.0
        }
        
        var totalnumberOfChapters:Int = 0
        var totalAmountOfTime:Int = 0
        
        for note in DataModel.notes {
            let chapters = note.readingRecord as! [String]
            
            totalnumberOfChapters += chapters.count
        }
        for note in DataModel.notes {
            let time = note.prayerRecord
            totalAmountOfTime += Int(time)
        }
        
        let daysLeft:Int = setDaysGoal - DataModel.notes.count
        daysLeftLabel.text = String(daysLeft)
        let readingProgress:Double = (Double(totalnumberOfChapters)/setReadingGoal)*100
        readingProgressLabel.text = "\(round(readingProgress))%"
        let prayingProgress:Double = ((Double(totalAmountOfTime)/60)/setPrayerTimeGoal)*100
        prayingProgressLabel.text = String(round(prayingProgress)) + "%"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profilePhoto.image = UIImage(named: "crown")
    }
    
    @IBAction func setGoals(_ sender: Any) {
        //Q: How to show the settings tab?
    }
    
    @IBAction func clearHistory(_ sender: Any) {
        
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileTableViewCell
        let note = DataModel.notes[(indexPath as NSIndexPath).row]
        
        if let date = note.date {
            cell.dateLabel.text = date
        }
        cell.weekdayLabel.text = note.day
        
        if let readingRecord = note.readingRecord as? [String] {
            var chaptersRead = ""
            for (index, chapter) in readingRecord.enumerated() {
                if index == (readingRecord.count - 1){
                    chaptersRead += "\(chapter)"
                } else {
                    chaptersRead += "\(chapter), "
                }
            }
            cell.chaptersRead.text = chaptersRead
        }
        cell.prayerTime.text = timeString(time: TimeInterval(note.prayerRecord))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let note = DataModel.notes[(indexPath as NSIndexPath).row]
            
        }
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
