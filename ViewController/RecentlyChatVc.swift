//
//  RecentlyChatVc.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 8/10/24.
//

import UIKit
import SDWebImage

class RecentlyChatVc: UIViewController {
    
    let gap:CGFloat = 10
    @IBOutlet weak var frequentlyChattedCollectionView: UICollectionView!
    let fetchFriendsChat = FetchAllFriendsChat()
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUi()
        self.registerXib()
        self.getAllData()
        // Do any additional setup after loading the view.
    }
    
    func updateUi() {
        
        recentTableView.separatorColor = UIColor.clear
        
        searchBar.barTintColor = UIColor.clear
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        searchBar.layer.borderColor = UIColor(red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 1.0).cgColor
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.cornerRadius = 15.0
        
        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        
        searchField.backgroundColor = UIColor.black
        searchField.textColor = UIColor.white
        searchField.inputAccessoryView = createToolbar()
        
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search chat here..", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 1.0)])
        
        
        if let textField = self.searchBar.value(forKey: "searchField") as? UITextField,
           let iconView = textField.leftView as? UIImageView {
            
            iconView.image = iconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            iconView.tintColor  = UIColor(red: 161.0/255, green: 161.0/255, blue: 161.0/255, alpha: 1.0)
        }
    }
    func getAllData() {
        
        
        fetchFriendsChat.authorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWY4MDVkNGY0ZTRmOWU5OWI5ZTQ3MDMiLCJhY2NvdW50TmFtZSI6ImlyYmF6SGV5d293LTEiLCJlbWFpbCI6ImlyYmF6MjAwMEBnbWFpbC5jb20iLCJlbWFpbFZlcmlmaWVkIjp0cnVlLCJhY2NvdW50SWQiOjIyNSwicGhvbmVOdW1iZXIiOiIiLCJpYXQiOjE3Mjk1NzAzMDYsImV4cCI6MTczMDQzNDMwNiwiYXVkIjoiVVNFUiIsInN1YiI6IkFVVEgifQ.2zQFZH2t9YmcREym9pWqGftMj8SadKWrM8ipQlw4zkw"
        
        fetchFriendsChat.fetchAllFriends { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    
                    self.recentTableView.reloadData()
                    
                }
                
            case .failure(let error):
                // Handle error
                print("Error fetching friends: \(error.localizedDescription)")
            }
        }
        
    }
    
    func registerXib () {
        
        
        recentTableView.register(UINib(nibName: "DetailCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        
    }
    
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexibleSpace, doneButton]
        return toolbar
    }
    
    
    @objc func doneButtonTapped() {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }
}

extension RecentlyChatVc: UITableViewDataSource,UITableViewDelegate {
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return fetchFriendsChat.fetchList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.selectionStyle = .none
        let obj = fetchFriendsChat.fetchList[indexPath.row]
        
      
        
        if let urlName = obj.members[0].avatar?.src {
            if let url = URL(string: urlName) {
                cell.imv.sd_setImage(with: url, placeholderImage: UIImage(named: "Human Icon"))
            }
        }
        
        cell.imv.layer.cornerRadius = cell.imv.frame.size.width / 2.0
        cell.imv.clipsToBounds = true
        
        
        
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
        cell.detailLabel.attributedText = attributedString
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  65
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
}



extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
