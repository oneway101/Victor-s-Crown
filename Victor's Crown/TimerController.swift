//
//  TimerController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/22/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit

class TimerController: UIViewController {
    
    
    @IBOutlet weak var timecode: UILabel!
    @IBOutlet weak var start: UIButton!
    
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    @IBAction func startButtonTapped(_ sender: Any) {
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    

}
