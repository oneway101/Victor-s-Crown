//
//  ProgressUIView.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/24/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit

class ProgressUIView: UIView {
    
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(4.0)
        context?.setStrokeColor(UIColor.blue.cgColor)
        let rectangle = CGRect(x: 60,y: 170,width: 200,height: 80)
        context?.addRect(rectangle)
        context?.strokePath()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(rectangle)
    }
}
