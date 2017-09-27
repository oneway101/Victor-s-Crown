//
//  BiblesClient.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/6/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData

class BiblesClient: NSObject {
    
    static let sharedInstance = BiblesClient()
    var session = URLSession.shared    
    
    // MARK: Bibles API
    
    func getBookList(_ completionHandler: @escaping (_ bookResult: [Book]?, _ chapterResult: [Chapter]?, _ error: NSError?) -> Void) {
        let versionID = "eng-KJV"
        let includeChapters = "?include_chapters=true"
        let urlString = "https://bibles.org/v2/versions/\(versionID)/books.js"+includeChapters
        
        let username = Constants.API.Key
        let password = "pass"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let task = taskForGETMethod(urlString, base64LoginString) { (parsedResult, error) in
            
            // display error
            func displayError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                let errorString = error?.localizedDescription
                displayError("\(errorString!)")
                return
            }
            
            /* GUARD: Is the "response" key in our result? */
            guard let response = parsedResult?[Constants.ResponseKeys.Response] as? [String:AnyObject] else {
                displayError("Cannot find key '\(Constants.ResponseKeys.Response)' in \(String(describing: parsedResult))")
                return
            }
            
            /* GUARD: Is the "books" key in our response? */
            guard let books = response[Constants.ResponseKeys.Books] as? [[String:AnyObject]] else {
                displayError("Cannot find key '\(Constants.ResponseKeys.Books)' in \(response)")
                return
            }
            
            /* MARK: Find Bible book lists and number of chapters in each book */
            var bookLists:[Book] = []
            var allChapters:[Chapter] = []
            
            for book in books {
                guard let bookName = book[Constants.ResponseKeys.Name] as? String else {
                    displayError("Cannot find key '\(Constants.ResponseKeys.Name)' in \(book)")
                    return
                }
                
                guard let bookId = book[Constants.ResponseKeys.Id] as? String else {
                    displayError("Cannot find key '\(Constants.ResponseKeys.Id)' in \(book)")
                    return
                }
                
                guard let chapters = book[Constants.ResponseKeys.Chapters] as? [[String:AnyObject]] else {
                    displayError("Cannot find key '\(Constants.ResponseKeys.Chapters)' in \(book)")
                    return
                }
                
                /* Save Book object to core data */
                performUIUpdatesOnMain {
                    let context = CoreDataStack.getContext()
                    let book:Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context ) as! Book
                    book.name = bookName
                    book.id = bookId
                    book.numOfChapters = Int16(chapters.count)
                    bookLists.append(book)
                    CoreDataStack.saveContext()
                    
                    for chapterObj in chapters {
                        guard let chapterNumber = chapterObj[Constants.ResponseKeys.Chapter] as? String else {
                            displayError("Cannot find key '\(Constants.ResponseKeys.Chapter)' in \(chapterObj)")
                            return
                        }
                        guard let chapterId = chapterObj[Constants.ResponseKeys.Id] as? String else {
                            displayError("Cannot find key '\(Constants.ResponseKeys.Id)' in \(chapterObj)")
                            return
                        }
                        
                        /* Save Chapter object to core data */
                        let context = CoreDataStack.getContext()
                        let chapter:Chapter = NSEntityDescription.insertNewObject(forEntityName: "Chapter", into: context ) as! Chapter
                        chapter.number = chapterNumber
                        chapter.id = chapterId
                        chapter.book = book
                        allChapters.append(chapter)
                        CoreDataStack.saveContext()
                    }
                    
                }
                
            }
            completionHandler(bookLists, allChapters, nil)
            
        }
        
        // start the task!
        task.resume()
    }
    
    func getScriptures(_ selectedChapter:Chapter, _ chapterId:String, _ completionHandler: @escaping (_ result: [Scripture]?, _ error: NSError?) -> Void) {
        
        let urlString = "https://bibles.org/v2/chapters/\(chapterId)/verses.js"
        
        let username = Constants.API.Key
        let password = "pass"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let task = taskForGETMethod(urlString, base64LoginString) { (parsedResult, error) in
            
            // display error
            func displayError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                let errorString = error?.localizedDescription
                displayError("\(errorString!)")
                return
            }
            
            /* GUARD: Is the "response" key in our result? */
            guard let response = parsedResult?[Constants.ResponseKeys.Response] as? [String:AnyObject] else {
                displayError("Cannot find key '\(Constants.ResponseKeys.Response)' in \(String(describing: parsedResult))")
                return
            }
            
            /* GUARD: Is the "verses" key in our response? */
            guard let verses = response[Constants.ResponseKeys.Verses] as? [[String:AnyObject]] else {
                displayError("Cannot find key '\(Constants.ResponseKeys.Verses)' in \(response)")
                return
            }
            
            performUIUpdatesOnMain {
                var scriptures:[Scripture] = []
                
                for verseObj in verses {
                    
                    guard let verseNumber = verseObj[Constants.ResponseKeys.Verse] as? String else {
                        displayError("Cannot find key '\(Constants.ResponseKeys.Verse)' in \(verseObj)")
                        return
                    }
                    guard let verseText = verseObj[Constants.ResponseKeys.Text] as? String else {
                        displayError("Cannot find key '\(Constants.ResponseKeys.Text)' in \(verseObj)")
                        return
                    }
                    
                    
                    /* Save Scripture object to core data */
                    let context = CoreDataStack.getContext()
                    let scripture:Scripture = NSEntityDescription.insertNewObject(forEntityName: "Scripture", into: context ) as! Scripture
                    
                    scripture.verseText = verseText as NSObject
                    scripture.verseNumber = verseNumber
                    scripture.chapter = selectedChapter
                    scripture.chapterId = chapterId
                    scriptures.append(scripture)
                    CoreDataStack.saveContext()
                }
                
                completionHandler(scriptures, nil)
            }
            
            
            
        }
        
        // start the task!
        task.resume()
    }
    
    // MARK: Helpers
    
    // MARK: GET Method
    func taskForGETMethod(_ urlString: String, _ loginString: String, _ completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Build the URL, Configure the request */
        let urlString = urlString
        let request = NSMutableURLRequest(url:URL(string:urlString)!)
        request.httpMethod = "GET"
        request.setValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")

        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                let errorString = error?.localizedDescription
                sendError("\(errorString!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }

    
    // MARK: Helper for Creating a URL from Parameters
    
    private func biblesURLFromParameters(_ parameters: [String:String]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.API.Scheme
        components.host = Constants.API.Host
        components.path = Constants.API.Path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
}



