//
//  PrivateChat.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 23/10/24.
//

import UIKit

class PrivateChat: UIViewController {
    
    var myDictionary = [String: Bool]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imv: UIImageView!
    var obj:Chat?
    var mainArray = [Message]()
    let previousChat = FetchPreviousMessages()
    var userid = "65f805d4f4e4f9e99b9e4703"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seUpUI()
        self.getAllData()
    }
    
    func seUpUI () {
        tableView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        userName.text = obj?.members[0].accountName ?? "No Name"
        if let urlName = obj?.members[0].avatar?.src {
            if let url = URL(string: urlName) {
                self.imv.sd_setImage(with: url, placeholderImage: UIImage(named: "Human Icon"))
            }
        }
        imv.layer.cornerRadius  = imv.frame.size.width / 2.0
        imv.clipsToBounds = true
        //self.getAllData()
        
        previousChat.chatId = obj?.id ?? ""
        previousChat.authorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWY4MDVkNGY0ZTRmOWU5OWI5ZTQ3MDMiLCJhY2NvdW50TmFtZSI6ImlyYmF6SGV5d293LTEiLCJlbWFpbCI6ImlyYmF6MjAwMEBnbWFpbC5jb20iLCJlbWFpbFZlcmlmaWVkIjp0cnVlLCJhY2NvdW50SWQiOjIyNSwicGhvbmVOdW1iZXIiOiIiLCJpYXQiOjE3Mjk1NzAzMDYsImV4cCI6MTczMDQzNDMwNiwiYXVkIjoiVVNFUiIsInN1YiI6IkFVVEgifQ.2zQFZH2t9YmcREym9pWqGftMj8SadKWrM8ipQlw4zkw"
        
        tableView.register(UINib(nibName: "UserChatCell", bundle: nil), forCellReuseIdentifier: "UserChatCell")
        tableView.register(UINib(nibName: "ReplyChatCell", bundle: nil), forCellReuseIdentifier: "ReplyChatCell")
        //tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorColor = UIColor.clear
        
    }
    
    func getAllData() {
        
        
        
        previousChat.fetchAllFriends { result in
            switch result {
            case .success(_):
                
                let ar = self.previousChat.fetchList.reversed()
                
                for item in ar {
                    if self.myDictionary[item.id] ?? false {
                        
                    }
                    else {
                        self.mainArray.append(item)
                    }
                    
                    self.myDictionary[item.id] = true
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating();
                    self.activityIndicator.isHidden = true
                    self.tableView.reloadData()
                }
               
                
                print("Hello world")
                
            case .failure(_):
                print("Hello world")
                
            }
        }
        
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension PrivateChat: UITableViewDataSource,UITableViewDelegate {
    
    
    
    
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
        
        
        return  100
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == previousChat.fetchList.count - 1 , previousChat.shouldFetch {
            activityIndicator.startAnimating();
            activityIndicator.isHidden = false
            self.getAllData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row % 2 == 0 {
            let userChatCell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell", for: indexPath) as! UserChatCell
            userChatCell.selectionStyle = .none
            return userChatCell
        }
        
        
     
        let replyChatCell = tableView.dequeueReusableCell(withIdentifier: "ReplyChatCell", for: indexPath) as! ReplyChatCell
        replyChatCell.selectionStyle = .none
        return replyChatCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
}
