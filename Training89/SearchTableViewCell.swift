//
//  SearchTableViewCell.swift
//  Training89
//
//  Created by dinh trong thang on 7/27/16.
//  Copyright © 2016 dinh trong thang. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var songLabel : UILabel!
    @IBOutlet var detailLabel : UILabel!
    @IBOutlet var searchImageView: UIImageView!

}
