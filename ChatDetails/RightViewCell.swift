//
//  RightViewCell.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit

class RightViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.rounded(radius: 12)
      
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    func configureCell(text: String ,date: String) {
        textMessageLabel.text = text
        timeLabel.text = date
    }
}
