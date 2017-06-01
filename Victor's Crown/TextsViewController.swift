//
//  TextsViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/31/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit

class TextsViewController: UIViewController, UINavigationControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: Create a button navigation title
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitle("Psalms", for: .normal)
        button.setTitleColor(UIColor(red: 3/255, green: 121/255, blue: 251/255, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(self.clickOnTitle), for: .touchUpInside)
        self.navigationItem.titleView = button
    }
    
    func clickOnTitle(button: UIButton) {
        performSegue(withIdentifier: "ChapterList", sender: self)
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
