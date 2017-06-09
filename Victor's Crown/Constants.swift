//
//  Constants.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/6/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation

// MARK: - Constants

extension BiblesClient {
    
    //let token:String = "JLHmbY2si2lgdwgy0NWpCNm7oZhdCgSxDfsSHFtu"
    
    // MARK: Bibles API
    struct Constants {
        
        static let APIKey = "JLHmbY2si2lgdwgy0NWpCNm7oZhdCgSxDfsSHFtu"
        
        static let APIScheme = "https"
        static let APIHost = "bibles.org"
        static let APIPath = "/v2/versions"
        
        }
    
    // MARK: Bibles API Parameter Keys
    struct ParameterKeys {
        static let Version = "version"
        static let Books = "books"
        static let Chapters = "chapters"
        static let Path = "path"
        static let Name = "name"
        static let Id = "id"
    }
    
    // MARK: Bibles API Parameter Values
    struct BiblesParameterValues {
        static let Response = "resonse"
        static let Books = "books"
        static let Search = "search"
        static let Result = "result"
        static let Passages = "passages"
        static let Text = "text"
    }
    
    // MARK: Bibles API Response Keys
    struct BiblesResponseKeys {
        static let Status = "stat"
    }
    
    // MARK: Bibles API Response Values
    struct BiblesResponseValues {
        static let OKStatus = "ok"
    }
    
    
}

