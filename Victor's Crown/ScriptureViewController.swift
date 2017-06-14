//
//  ScriptureViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/11/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit

class ScriptureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private let reuseIdentifier = "ScriptureCell"
    var selectedBook:Book!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return BiblesClient.sharedInstance.bible.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BiblesClient.sharedInstance.bible.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ScriptureCell
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
