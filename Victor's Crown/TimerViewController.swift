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
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saveTimecode: UIButton!
    
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false
    
    let today = Date()
    var timestamp = ""
    var dayOfWeek = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveTimecode.isEnabled = false
        doneButton.isEnabled = false
        timestamp = DateFormatter.localizedString(from: today, dateStyle: .short, timeStyle: .none)
        dayOfWeek = today.dayOfWeek()!
        debugPrint("today's date: \(timestamp)")
    }
    
    func runTimer(){
        if isTimerRunning {
            timer.invalidate()
            start.setTitle("Start", for: .normal)
            
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
            start.setTitle("Pause", for: .normal)
        }
    }
    
    func updateTimer(){
        seconds += 1
        timecode.text = timeString(time: TimeInterval(seconds))
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        timer.invalidate()
        start.setTitle("Start", for: .normal)
        isTimerRunning = false
        start.isEnabled = false
        saveTimecode.isEnabled = true
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        runTimer()
        isTimerRunning = !isTimerRunning
        doneButton.isEnabled = true
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        timer.invalidate()
        seconds = 0
        timecode.text = timeString(time: TimeInterval(seconds))
        start.setTitle("Start", for: .normal)
        isTimerRunning = false
        start.isEnabled = true
        doneButton.isEnabled = false
        saveTimecode.isEnabled = false
    }
    
    @IBAction func saveButtonTapped(_ sender:Any) {
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
            debugPrint("Unable to Perform Fetch Request")
            debugPrint("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        if let data = fetchedResultsController.fetchedObjects, data.count > 0 {
            data[0].prayerRecord += Int16(seconds)
            debugPrint("Prayer time has been upated to \(data[0].prayerRecord).")
            CoreDataStack.saveContext()
        } else {
            let note:Note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context ) as! Note
            note.date = timestamp
            note.day = dayOfWeek
            note.prayerRecord = Int16(seconds)
            note.readingRecord = [String]() as NSObject
            CoreDataStack.saveContext()
            debugPrint("Today's prayer record has been saved.")
        }
        seconds = 0
        timecode.text = timeString(time: TimeInterval(seconds))
        saveTimecode.isEnabled = false
        doneButton.isEnabled = false
        start.isEnabled = true
    }

    
    

}
