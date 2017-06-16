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
private let segueIdentifier = "ScriptureViewSegue"

class BookChapterListViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var bibleCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var selectedBook:Book!
    var numberOfChapters:Int16!
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bibleCollectionView.delegate = self
        bibleCollectionView.dataSource = self

        // MARK: Set spacing between chapters
        //let space: CGFloat = 1.5
        let viewWidth = self.view.frame.width
        let dimension: CGFloat = (viewWidth-20)/5
        
        //flowLayout.minimumInteritemSpacing = space
        //flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataModel.chapters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookChapterCell
        
        //Q: Getting chapters dictionary from selectedBook?
        let chapter = DataModel.chapters[(indexPath as NSIndexPath).row]
        
        cell.bookChapterLabel.text = chapter.number
//        for index in 1...numberOfChapters  {
//            cell.bookChapterLabel.text! = "\(index)"
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! BookChapterCell
        print("*** selectedCell ***: \(selectedCell)")
        let selectedChapter = DataModel.chapters[indexPath.row]
        
        performSegue(withIdentifier: segueIdentifier, sender: selectedChapter)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let controller = segue.destination as! ScriptureViewController
            let selectedChapter = sender as! Chapter
            controller.selectedChapter = selectedChapter
        }
    }
    
    @IBAction func cancel(){
        dismiss(animated: true, completion: nil)
    }

}
