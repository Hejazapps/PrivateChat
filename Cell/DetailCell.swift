//
//  DetailCell.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 8/10/24.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var imv: UIImageView!
    
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
