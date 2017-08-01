//
//  Constants.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/6/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation

// MARK: - Constants

struct Constants {
    
    
    // MARK: Bibles API
    struct API {
        
        static let Key = "JLHmbY2si2lgdwgy0NWpCNm7oZhdCgSxDfsSHFtu"
        
        static let Scheme = "https"
        static let Host = "bibles.org"
        static let Path = "/v2/versions"
        
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
    
    // Mark: User Defaults
    struct UserDefaults {
        static let StartDate = "startDate"
        static let EndDate = "endDate"
        static let DaysGoal = "daysGoal"
        static let ReadingGoal = "readingGoal"
        static let PrayerTimeGoal = "prayerTimeGoal"
        
        static let SelectedBookName = "selectedBookName"
        static let SelectedChapterId = "selectedChapterId"
        static let SelectedChapterNumber = "selectedChapterNumber"
    }
    
    
}

