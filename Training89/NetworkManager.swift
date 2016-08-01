//
//  NetworkManager.swift
//  Training89
//
//  Created by dinh trong thang on 7/30/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import Foundation
import UIKit
class NetworkManagerSearch {
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask : NSURLSessionDataTask?
    var songs = [Song]()
    var delegate:NetworkManagerDelegate!

    //use delegate
    func getDatafromSearchText(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            if dataTask != nil {
                dataTask?.cancel()
            }
            let charSet = NSCharacterSet.URLQueryAllowedCharacterSet()
            let stringTerm = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(charSet)!
            let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(stringTerm)")
            dataTask = session.dataTaskWithURL(url!) {
                data,response,error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("1")
                        self.updateSongs(data)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func updateSongs(data:NSData?) {
        songs.removeAll()
        do {
            if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                // Get the results array
                if let array: AnyObject = response["results"] {
                    for trackDictonary in array as! [AnyObject] {
                        if let trackDictonary = trackDictonary as? [String: AnyObject] {
                            // Parse the search result
                            let name = trackDictonary["trackName"] as? String
                            let artist = trackDictonary["artistName"] as? String
                            let imageUrl = trackDictonary["artworkUrl60"] as? String
                            self.songs.append(Song(song: name!, detail: artist!, imageURL: imageUrl!))
                        } else {
                            print("Not a dictionary")
                        }
                    }
                } else {
                    print("Results key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        self.delegate.assignData(songs)
        
    }
    
    
    
    
    //use notification
    func getDataFromSearchTextAndPostNotification(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            if dataTask != nil {
                dataTask?.cancel()
            }
            let charSet = NSCharacterSet.URLQueryAllowedCharacterSet()
            let stringTerm = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(charSet)!
            let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(stringTerm)")
            dataTask = session.dataTaskWithURL(url!) {
                data,response,error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("1")
                        self.updateSongsNotification(data)
                    }
                }
            }
            dataTask?.resume()
        }
        
    }
    
    func updateSongsNotification(data:NSData?) {
        songs.removeAll()
        do {
            if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                // Get the results array
                if let array: AnyObject = response["results"] {
                    for trackDictonary in array as! [AnyObject] {
                        if let trackDictonary = trackDictonary as? [String: AnyObject] {
                            // Parse the search result
                            let name = trackDictonary["trackName"] as? String
                            let artist = trackDictonary["artistName"] as? String
                            let imageUrl = trackDictonary["artworkUrl60"] as? String
                            self.songs.append(Song(song: name!, detail: artist!, imageURL: imageUrl!))
                        } else {
                            print("Not a dictionary")
                        }
                    }
                } else {
                    print("Results key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        NSNotificationCenter.defaultCenter().postNotificationName("songloaded", object: songs)
        
    }
    
    
    
    
    //use closure
    func getDataFromSearchTextUseClosure(searchBar:UISearchBar,closure:([Song])->()) {
        if !searchBar.text!.isEmpty {
            if dataTask != nil {
                dataTask?.cancel()
            }
            let charSet = NSCharacterSet.URLQueryAllowedCharacterSet()
            let stringTerm = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(charSet)!
            let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(stringTerm)")
            dataTask = session.dataTaskWithURL(url!) {
                data,response,error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("1")
                        self.updateSongsClosure(data)
                        closure(self.songs)
                    }
                }
            }
            dataTask?.resume()
        }

    }
    
    func updateSongsClosure(data:NSData?) {
        songs.removeAll()
        do {
            if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) as? [String: AnyObject] {
                
                // Get the results array
                if let array: AnyObject = response["results"] {
                    for trackDictonary in array as! [AnyObject] {
                        if let trackDictonary = trackDictonary as? [String: AnyObject] {
                            // Parse the search result
                            let name = trackDictonary["trackName"] as? String
                            let artist = trackDictonary["artistName"] as? String
                            let imageUrl = trackDictonary["artworkUrl60"] as? String
                            self.songs.append(Song(song: name!, detail: artist!, imageURL: imageUrl!))
                        } else {
                            print("Not a dictionary")
                        }
                    }
                } else {
                    print("Results key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
    }
}

protocol NetworkManagerDelegate {
    func assignData(songs:[Song])
}