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
    private let segueIdentifier = "ChapterListSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.bible.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BookNameCell
        
        let bookList = DataModel.bible[(indexPath as NSIndexPath).row]
        cell.bookNameLabel.text = bookList.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = DataModel.bible[(indexPath as NSIndexPath).row]
        print("*** selectedBook *** \(selectedBook)")
        self.performSegue(withIdentifier: segueIdentifier, sender: selectedBook)
    }


    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let controller = segue.destination as! BookChapterListViewController
            let selectedBook = sender as! Book
            controller.selectedBook = selectedBook
            controller.numberOfChapters = selectedBook.numOfChapters
        }
        
    }
 

}
