//
//  BookNameListViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/9/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData


class BookNameListController: UITableViewController {

    private let reuseIdentifier = "BookNameCell"
    private let segueIdentifier = "ScriptureViewSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BiblesClient.sharedInstance.bible.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BookNameCell
        
        let bookList = BiblesClient.sharedInstance.bible[(indexPath as NSIndexPath).row]
        cell.bookNameLabel.text = bookList.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = BiblesClient.sharedInstance.bible[(indexPath as NSIndexPath).row]
        print(selectedBook)
        self.performSegue(withIdentifier: segueIdentifier, sender: selectedBook)
    }


    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let controller = segue.destination as! ScriptureViewController
            let selectedBook = sender as! Book
            controller.selectedBook = selectedBook
        }
    }
 

}
