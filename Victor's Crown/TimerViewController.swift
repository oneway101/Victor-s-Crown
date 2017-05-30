//
//  TimerController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/22/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    
    @IBOutlet weak var timecode: UILabel!
    @IBOutlet weak var start: UIButton!
    
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false
    
    @IBAction func startButtonTapped(_ sender: Any) {
        runTimer()
        isTimerRunning = !isTimerRunning
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        timer.invalidate()
        seconds = 0
        timecode.text = timeString(time: TimeInterval(seconds))
        start.setTitle("Start", for: .normal)
        isTimerRunning = false
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
    
    func timeString(time:TimeInterval) -> String{
        let hours = Int(time)/3600
        let minutes = Int(time)/60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    

}
