//
//  DetailCell.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 8/10/24.
//

import UIKit
import SDWebImage

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
    
    func setUp(obj:Chat) {
        
        if let urlName = obj.members[0].avatar?.src {
            if let url = URL(string: urlName) {
                self.imv.sd_setImage(with: url, placeholderImage: UIImage(named: "Human Icon"))
            }
        }
        
        self.imv.layer.cornerRadius = self.imv.frame.size.width / 2.0
        self.imv.clipsToBounds = true
        
        
        
        let attributedString = NSMutableAttributedString()

        // Create a paragraph style with spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 5 // Adjust this value for more or less space

        // Title attributes
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle // Use paragraph style for title
        ]

        let name = obj.members[0].accountName ?? "No Name"
        let titleAttributedString = NSAttributedString(string: name, attributes: titleAttributes)

        // Add title to the attributed string
        attributedString.append(titleAttributedString)

        // Append newline character (optional, if you want a little gap)
        attributedString.append(NSAttributedString(string: "\n")) // Optional if you want a bit of extra space

        // Subtitle attributes
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle // Use the same paragraph style for subtitle
        ]

        let subtitleAttributedString = NSAttributedString(string: "But I am an expert in UKIT", attributes: subtitleAttributes)

        // Add subtitle to the attributed string
        attributedString.append(subtitleAttributedString)
        // Assign the attributed string to the label
        self.detailLabel.attributedText = attributedString
    }
    
}
