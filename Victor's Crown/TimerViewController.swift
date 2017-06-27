//
//  TimerController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/22/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: UIViewController {
    
    
    @IBOutlet weak var timecode: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var saveTimecode: UIButton!
    
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false
    
    let today = Date()
    var timestamp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveTimecode.isEnabled = false
        timestamp = DateFormatter.localizedString(from: today, dateStyle: .short, timeStyle: .none)
        print("today's date: \(timestamp)")
        //let isToday = Calendar.current.isDateInToday(today)
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        runTimer()
        isTimerRunning = !isTimerRunning
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        timer.invalidate()
        seconds = 0
        timecode.text = timeString(time: TimeInterval(seconds))
        start.setTitle("Start", for: .normal)
        isTimerRunning = false
        saveTimecode.isEnabled = false
    }
    
    @IBAction func saveButtonTapped(_ sender:Any) {
        print(seconds)
        fetchNotes()
    }

    func runTimer(){
        if isTimerRunning {
            timer.invalidate()
            start.setTitle("Start", for: .normal)
            saveTimecode.isEnabled = true
            
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
            start.setTitle("Pause", for: .normal)
            saveTimecode.isEnabled = false
        }
    }
    
    func updateTimer(){
        seconds += 1
        timecode.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String{
        let hours = Int(time)/3600
        let minutes = Int(time)/60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    
    func fetchNotes(){
        //MARK: Fetch Request
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "date = %@", timestamp)
        let context = CoreDataStack.getContext()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()

        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        if let data = fetchedResultsController.fetchedObjects, data.count > 0 {
            data[0].prayerRecord += Int16(seconds)
            print("Prayer time has been upated to \(data[0].prayerRecord).")
            CoreDataStack.saveContext()
        } else {
            let note:Note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context ) as! Note
            note.date = timestamp
            note.prayerRecord = Int16(seconds)
            note.readingRecord = ""
            CoreDataStack.saveContext()
            print("Today's prayer record has been saved.")
        }
    }
    
    

}
