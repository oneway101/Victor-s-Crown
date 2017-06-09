//
//  BiblesClient.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/6/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation
import CoreData

class BiblesClient: NSObject {
    
    static let sharedInstance = BiblesClient()
    var session = URLSession.shared
    
    //Q: Where to Create Shared Instance of Core Data of Books?
    var scriptures:[Book] = [Book]()
    
    // MARK: Bibles API
    
    func getScriptures(_ completionHandler: @escaping (_ result: [Book]?, _ error: NSError?) -> Void) {

        let urlString = "https://bibles.org/v2/versions/eng-GNTD/books.js"
        
        let username = Constants.APIKey
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
            
            /* GUARD: Did BiblesAPI return an error (stat != ok)? */
//            guard let stat = parsedResult?[BiblesResponseKeys.Status] as? String, stat == BiblesResponseValues.OKStatus else {
//                displayError("BiblesAPI returned an error. See error code and message in \(String(describing: parsedResult))")
//                return
//            }
            
            /* GUARD: Is the "response" key in our result? */
            guard let response = parsedResult?[BiblesParameterValues.Response] as? [String:AnyObject] else {
                displayError("Cannot find key '\(BiblesParameterValues.Response)' in \(String(describing: parsedResult))")
                return
            }
            
            /* GUARD: Is the "photo" key in photosDictionary? */
            guard let books = response[BiblesParameterValues.Books] as? [[String: AnyObject]] else {
                displayError("Cannot find key '\(BiblesParameterValues.Books)' in \(response)")
                return
            }
            
            performUIUpdatesOnMain {
                
                let context = CoreDataStack.getContext()
                
                for book in books {
                    guard let bookName = book[ParameterKeys.Name] as? String else {
                        displayError("Cannot find key '\(ParameterKeys.Name)' in \(books)")
                        return
                    }
                    let book:Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context ) as! Book

                    book.name = bookName
                    book.chapter = "1"
                    book.text = "sample text..."
                    self.scriptures.append(book)
                    CoreDataStack.saveContext()
                }
            }

            completionHandler(self.scriptures, nil)
            
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
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
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
    
    func getDataFromUrl(_ urlString: String, _ completionHandler: @escaping (_ imageData: Data?, _ error: String?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, error?.localizedDescription)
                return
            }
            completionHandler(data, nil)
        }
        task.resume()
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func biblesURLFromParameters(_ parameters: [String:String]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print(components.url!)
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
    
    // given a dictionary of parameters, covert unsafe ASCII characters and correctly formated url string.
    func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
}
