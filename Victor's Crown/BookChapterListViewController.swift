//
//  BibleViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/24/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "BookChapterCell"
//private let segueIdentifier = "ScriptureViewSegue"
private let segueIdentifier = "unWindToScriptureView"

class BookChapterListViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var bibleCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    //var selectedBook:Book!
    var numberOfChapters:Int!
    var selectedBookChaptersArray:[Chapter] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Q: Should I use the fetch request to sort chapters of the selected book?
        //What would be the better way to sort the chapters array?
        numberOfChapters = Int(DataModel.selectedBook!.numOfChapters)
        selectedBookChaptersArray = (DataModel.selectedBook?.chapters?.allObjects as! [Chapter]).sorted{Int($0.number!)! < Int($1.number!)!}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bibleCollectionView.delegate = self
        bibleCollectionView.dataSource = self

        // MARK: Set spacing between chapters
        let viewWidth = self.view.frame.width
        let dimension: CGFloat = (viewWidth-20)/5
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfChapters
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookChapterCell
        let chapter = selectedBookChaptersArray[(indexPath as NSIndexPath).row]
        cell.bookChapterLabel.text = chapter.number
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! BookChapterCell
        let selectedChapter = selectedBookChaptersArray[(indexPath as NSIndexPath).row]
        DataModel.selectedChapter = selectedChapter
        DataModel.selectedChapterId = selectedChapter.id!
        print("You've selected Chapter \(selectedChapter.id)")
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == segueIdentifier {
//            let controller = segue.destination as! ScriptureViewController
//            let selectedChapter = sender as! Chapter
//            controller.selectedChapter = selectedChapter
//        }
//    }
    
    @IBAction func cancel(){
        dismiss(animated: true, completion: nil)
    }

}
