//
//  UserChatCell.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 24/10/24.
//

import UIKit

class UserChatCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLbl: PaddingLabel!
    @IBOutlet weak var lbl: PaddingLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.configureCell(messageType: .sent, cornerRadius: 15.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(messageType: PaddingLabel.MessageType?, cornerRadius: CGFloat = 0.0) {
        guard messageType != nil else { return }
        lbl.makeChatBubble(cornerRadius: cornerRadius, messageType: .sent)
    }
    
}
