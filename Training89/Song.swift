//
//  Song.swift
//  Training89
//
//  Created by dinh trong thang on 7/27/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import Foundation
class Song {
    var song:String!
    var detail:String!
    var imageURL:String!
    init(song:String,detail:String,imageURL:String) {
        self.song=song
        self.detail=detail
        self.imageURL=imageURL
    }
}