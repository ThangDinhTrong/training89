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

        self.navigationController?.navigationBar.backgroundColor = UIColor.yellowColor()
        self.tableView.separatorColor = UIColor.whiteColor()
        tableView.setContentOffset(CGPointZero, animated:true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchTableViewController.songsLoadedAndUseNotification), name: "songloaded", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete  implementation, return the number of rows
        return songs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell

        // Configure the cell...
        cell.songLabel.text = songs[indexPath.row].song
        cell.detailLabel.text = songs[indexPath.row].detail
        self.loadImageFromUrl(songs[indexPath.row].imageURL, view: cell.imageView!)
        return cell
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        let url = NSURL(string: url)!

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            if let data = responseData{

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        task.resume()
    }
    
    func songsLoadedAndUseNotification(notification: NSNotification) {
        let object = notification.object as! [Song]
        self.songs.removeAll()
        self.songs = object
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}




extension SearchTableViewController:NetworkManagerDelegate {
    func assignData(songs:[Song]) {
        self.songs = songs
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}





extension SearchTableViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        
        
        
        //use delegate
//        let objNetwork = NetworkManagerSearch()
//        objNetwork.delegate = self
//        objNetwork.getDatafromSearchText(self.searchBar)
        
        
        
        
        //use notification
//        let objNetwork = NetworkManagerSearch()
//        objNetwork.getDataFromSearchTextAndPostNotification(self.searchBar)
        
        
        
        
        //use closure
        let objNetwork = NetworkManagerSearch()
        objNetwork.getDataFromSearchTextUseClosure(self.searchBar) {
            songs in
            self.songs.removeAll()
            self.songs = songs
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    
    }
}












