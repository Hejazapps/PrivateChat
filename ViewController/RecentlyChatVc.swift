//
//  RecentlyChatVc.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 8/10/24.
//

import UIKit
import SDWebImage

class RecentlyChatVc: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
        
        activityIndicator.isHidden = true
        recentTableView.separatorColor = UIColor.clear
        
        searchBar.barTintColor = UIColor.clear
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        searchBar.layer.borderColor = UIColor(red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 1.0).cgColor
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.cornerRadius = 15.0
        
        let searchField = searchBar.value(forKey: "searchField") as! UITextField
        
        searchField.backgroundColor = UIColor.black
        searchField.textColor = UIColor.white
        
        
        
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
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == fetchFriendsChat.fetchList.count - 1 , fetchFriendsChat.shouldFetch {
            activityIndicator.startAnimating();
            activityIndicator.isHidden = false
            fetchFriendsChat.fetchAllFriends { result in
                
                DispatchQueue.main.async {
                    tableView.reloadData()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.recentTableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.selectionStyle = .none
        let obj = fetchFriendsChat.fetchList[indexPath.row]
        
        cell.setUp(obj: obj)
    
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  70
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let obj = fetchFriendsChat.fetchList[indexPath.row]
        let vc = storyboard.instantiateViewController(withIdentifier: "PrivateChat") as! PrivateChat
        vc.obj = obj
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
       
        
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
