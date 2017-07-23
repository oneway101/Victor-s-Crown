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
        profilePhoto.image = UIImage(named: "no-profile")        
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return DataModel.notes.count
        return 7
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
                chaptersRead += "\(chapter), "
                if index == (readingRecord.count - 1){
                    chaptersRead += "\(chapter)"
                }
            }
            cell.chaptersRead.text = chaptersRead
        }
        cell.prayerTime.text = timeString(time: TimeInterval(note.prayerRecord))
        
        return cell
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
