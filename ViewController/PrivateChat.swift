//
//  PrivateChat.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 23/10/24.
//

import UIKit

class PrivateChat: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imv: UIImageView!
    
    @IBOutlet weak var growingTextView: GrowingTextView!
    
    private var userid = "65f805d4f4e4f9e99b9e4703"
    
    private var myDictionary = [String: Bool]()
    private var mainArray = [Message]()
    private let previousChat = FetchPreviousMessages()
    
    var obj: Chat?
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        growingTextView.maxHeight = 50
        growingTextView.text = "Write message"
        growingTextView.textColor = UIColor.lightGray
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.seUpUI()
    }
}

// MARK: - UITableViewDataSource
extension PrivateChat: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = mainArray[indexPath.row]
        
        print("message i found \(obj.message)")
        if obj.sender == userid {
            let userChatCell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell", for: indexPath) as! UserChatCell
            userChatCell.selectionStyle = .none
            userChatCell.lbl.text = obj.message
            tableView.reloadRows(at: [indexPath], with: .none)
            return userChatCell
        }
        
        let replyChatCell = tableView.dequeueReusableCell(withIdentifier: "ReplyChatCell", for: indexPath) as! ReplyChatCell
        replyChatCell.selectionStyle = .none
        replyChatCell.lbl.text = obj.message
        tableView.reloadRows(at: [indexPath], with: .none)
        return replyChatCell
    }
}

// MARK: - UITableViewDelegate
extension PrivateChat: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { CGFLOAT_MIN }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { CGFLOAT_MIN }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { mainArray.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("fetch is called here")
        if indexPath.row == previousChat.fetchList.count - 1 , previousChat.shouldFetch {
           
            activityIndicator.startAnimating();
            activityIndicator.isHidden = false
            getAllData()
        }
    }
}

// MARK: - Private Methods
private extension PrivateChat {
    func seUpUI () {
        userName.text = obj?.members[0].accountName ?? "No Name"
        
        if let urlName = obj?.members[0].avatar?.src {
            if let url = URL(string: urlName) {
                self.imv.sd_setImage(with: url, placeholderImage: UIImage(named: "Human Icon"))
            }
        }
        
        imv.layer.cornerRadius  = imv.frame.size.width / 2.0
        imv.clipsToBounds = true
        self.getAllData()
        
       
        
        tableView.register(UINib(nibName: "UserChatCell", bundle: nil), forCellReuseIdentifier: "UserChatCell")
        tableView.register(UINib(nibName: "ReplyChatCell", bundle: nil), forCellReuseIdentifier: "ReplyChatCell")
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorColor = UIColor.clear
        tableView.clipsToBounds = true
    }
    
    func getAllData() {
        
        print("id has been selected \(obj?.id ?? "")")
        previousChat.chatId = obj?.id ?? ""
        previousChat.authorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWY4MDVkNGY0ZTRmOWU5OWI5ZTQ3MDMiLCJhY2NvdW50TmFtZSI6ImlyYmF6SGV5d293LTEiLCJlbWFpbCI6ImlyYmF6MjAwMEBnbWFpbC5jb20iLCJlbWFpbFZlcmlmaWVkIjp0cnVlLCJhY2NvdW50SWQiOjIyNSwicGhvbmVOdW1iZXIiOiIiLCJpYXQiOjE3Mjk1NzAzMDYsImV4cCI6MTczMDQzNDMwNiwiYXVkIjoiVVNFUiIsInN1YiI6IkFVVEgifQ.2zQFZH2t9YmcREym9pWqGftMj8SadKWrM8ipQlw4zkw"
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
                
            case .failure(let error):
                print("[PrivateChat] Failed to fetch previous chat with error: \(error)")
            }
        }
    }
}
