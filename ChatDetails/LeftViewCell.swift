//
//  LeftViewCell.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit

class LeftViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
        messageContainerView.layer.cornerRadius = 15.0
        messageContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        messageContainerView.layer.masksToBounds = true
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    func configureCell(text: String ,date: String) {
        textMessageLabel.text = text
    }
    
    
    
}

