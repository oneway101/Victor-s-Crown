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
    }
    
    // MARK: Bibles API Response Keys
    struct ResponseKeys {
        static let Response = "response"
        static let Books = "books"
        static let Chapters = "chapters"
        static let Chapter = "chapter"
        static let Verses = "verses"
        static let Verse = "verse"
        static let Name = "name"
        static let Id = "id"
        static let Text = "text"
        static let Search = "search"
        static let Result = "result"
        static let Passages = "passages"
    }
    
    
}

