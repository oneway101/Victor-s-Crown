//
//  GCDBlackBox.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/7/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
