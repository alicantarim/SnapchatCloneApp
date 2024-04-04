//
//  FeedTableViewCell.swift
//  SnapchatClone
//
//  Created by Alican TARIM on 2.04.2024.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var feedUserNameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
