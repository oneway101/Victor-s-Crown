//
//  BibleViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/24/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BookChapterCell"

class BookChapterListViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var bibleCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var chapterNum = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    
    
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
    
    @IBAction func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterNum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookChapterCell
        
        let chapter = chapterNum[(indexPath as NSIndexPath).row]
        cell.bookChapterLabel.text! = String(chapter)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BookChapterCell
        
    }

}
