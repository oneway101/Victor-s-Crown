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
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var readingProgress: UILabel!
    @IBOutlet weak var prayingLabel: UILabel!
    @IBOutlet weak var prayingProgress: UILabel!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profilePhoto.image = UIImage(named: "crown")        
    }
    
    @IBAction func setGoals(_ sender: Any) {
        //Q: How to show settings tab?
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
