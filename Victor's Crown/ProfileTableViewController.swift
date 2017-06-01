//
//  ProfileTableViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/25/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit

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
    
    let historyData = [
        [   "day": "Sunday",
            "reading": "Psalms 1",
            "praying": "00:45"
        ],
        [   "day": "Monday",
            "reading": "Psalms 2-3",
            "praying": "00:55"
        ],
        [   "day": "Tuesday",
            "reading": "Psalms 4-7",
            "praying": "00:22"
        ],
        [   "day": "Wednesday",
            "reading": "Psalms 8",
            "praying": "01:10"
        ],
        [   "day": "Thursday",
            "reading": "Psalms 9-15",
            "praying": "00:05"
        ],
        [   "day": "Friday",
            "reading": "Psalms 16",
            "praying": "01:12"
        ],
        [   "day": "Saturday",
            "reading": "Psalms 17-20",
            "praying": "0:18"
        ]
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profilePhoto.image = UIImage(named: "no-profile")
        currentDate()
        
    }
    
    func currentDate()-> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date)
        print(year)
        print(month)
        print(day)
        print(weekday)
        print(Date().dayOfWeek()!)
        return Date().dayOfWeek()!
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return profileTableView.frame.height / CGFloat(historyData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileTableViewCell
        let history = historyData[(indexPath as NSIndexPath).row]
        
        cell.day.text = history["day"]
        cell.chaptersRead.text = history["reading"]
        cell.prayerTime.text = history["praying"]
        
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
