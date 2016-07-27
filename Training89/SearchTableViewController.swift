//
//  SearchTableViewController.swift
//  Training89
//
//  Created by dinh trong thang on 7/27/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var songs = [Song]()
    var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell

        // Configure the cell...
        cell.songLabel.text = songs[indexPath.row].song
        cell.detailLabel.text = songs[indexPath.row].detail
        cell.imageView?.image = UIImage(named: "default")
        return cell
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
                            let imageUrl = trackDictonary["artworkUrl100"] as? String
//                            print(trackDictonary["artworkUrl100"])
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
        
        self.tableView.reloadData()

    }
    
}

extension SearchTableViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
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
}
















