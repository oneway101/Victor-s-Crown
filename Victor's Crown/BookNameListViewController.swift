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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.bookLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BookNameCell
        
        let bookList = DataModel.bookLists[(indexPath as NSIndexPath).row]
        cell.bookNameLabel.text = bookList.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = DataModel.bookLists[(indexPath as NSIndexPath).row]
        DataModel.selectedBook = selectedBook
        DataModel.selectedBookName = selectedBook.name!
        print("You've selected book: \(selectedBook.name!)")
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
 

}
