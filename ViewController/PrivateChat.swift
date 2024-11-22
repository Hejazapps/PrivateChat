//
//  PrivateChat.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 23/10/24.
//

import UIKit
import SocketIO

class PrivateChat: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imv: UIImageView!
    
    @IBOutlet weak var bottomSpaceView: NSLayoutConstraint!
    @IBOutlet weak var growingTextView: GrowingTextView!
    
    private var userid = "65f805d4f4e4f9e99b9e4703"
    
    private var myDictionary = [String: Bool]()
    private var mainArray = [Message]()
    private let previousChat = FetchPreviousMessages()
    var isKeyboardShowing = false
    
    var obj: Chat?
    
    //  self.mainArray.insert(obj, at: 0)
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func extractHourAndMinute12HourFormat(from timestamp: String) -> String? {
        // Create a DateFormatter to parse the input string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Convert the string to a Date
        if let date = dateFormatter.date(from: timestamp) {
            // Create another DateFormatter to format the Date to "hh:mm a"
            let hourMinuteFormatter = DateFormatter()
            hourMinuteFormatter.dateFormat = "hh:mm a"
            
            // Get the hour and minute as a string
            return hourMinuteFormatter.string(from: date)
        } else {
            // Return nil if the date format is invalid
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        growingTextView.maxHeight = 50
        growingTextView.text = "Write message"
        growingTextView.textColor = UIColor.lightGray
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.seUpUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        let jwtToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NzNmMDY3Y2Q2NTc2YTZhNDgzNTY0NDQiLCJyb2xlIjoiVVNFUiIsImFjY291bnROYW1lIjoiYWFyYXZfMDkxIiwiZW1haWwiOiJ0ZXN0dXNlcjFAZ21haWwuY29tIiwiZW1haWxWZXJpZmllZCI6dHJ1ZSwiYWNjb3VudElkIjoxLCJwaG9uZU51bWJlciI6Ijk4NzY1NDMyMTAiLCJpYXQiOjE3MzIzMjU1NDQsImV4cCI6MTczMzE4OTU0NCwiYXVkIjoiVVNFUiIsInN1YiI6IkFVVEgifQ.3ZR77-nZ6GrHi8ByqEmbtcWEpPGv3ORoFo6QomYnuhw"

        // Initialize the socket connection with the JWT token
        SocketManagerHelper.shared.setupSocket(withAuthToken: jwtToken)
        
      }

    
    @objc func dismissKeyboard() {
        
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Get the first window associated with the window scene
            windowScene.windows.first?.endEditing(true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        
        tableView.reloadData()
        isKeyboardShowing = false
        self.bottomSpaceView.constant = 0
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
         
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if growingTextView.text.contains(find: "Write message") {
            
            growingTextView.text = ""
            growingTextView.textColor = UIColor.white
        }
        
        isKeyboardShowing = true
        
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            let keyboardHeight = keyboardFrame.height
            
            self.bottomSpaceView.constant = keyboardHeight
            
        }
        
        
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
        
    }
}

// MARK: - UITableViewDataSource
extension PrivateChat: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = mainArray[indexPath.row]
        
        print("message i found \(obj.message)")
        if obj.sender == userid {
            let userChatCell = tableView.dequeueReusableCell(withIdentifier: "RightViewCell", for: indexPath) as! RightViewCell
            userChatCell.selectionStyle = .none
            print("date i got \(obj.createdAt)")
            userChatCell.configureCell(text: obj.message, date: self.extractHourAndMinute12HourFormat(from: obj.createdAt) ?? "")
            
            return userChatCell
        }
        
        let replyChatCell = tableView.dequeueReusableCell(withIdentifier: "LeftViewCell", for: indexPath) as! LeftViewCell
        replyChatCell.selectionStyle = .none
        replyChatCell.configureCell(text: obj.message, date: self.extractHourAndMinute12HourFormat(from: obj.createdAt) ?? "")
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
        
        
        
        tableView.register(UINib(nibName: "RightViewCell", bundle: nil), forCellReuseIdentifier: "RightViewCell")
        tableView.register(UINib(nibName: "LeftViewCell", bundle: nil), forCellReuseIdentifier: "LeftViewCell")
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorColor = UIColor.clear
        tableView.clipsToBounds = true
    }
    
    func getAllData() {
        
        print("id has been selected \(obj?.id ?? "")")
        previousChat.chatId = obj?.id ?? ""
        previousChat.authorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NzNmMDY3Y2Q2NTc2YTZhNDgzNTY0NDQiLCJyb2xlIjoiVVNFUiIsImFjY291bnROYW1lIjoiYWFyYXZfMDkxIiwiZW1haWwiOiJ0ZXN0dXNlcjFAZ21haWwuY29tIiwiZW1haWxWZXJpZmllZCI6dHJ1ZSwiYWNjb3VudElkIjoxLCJwaG9uZU51bWJlciI6Ijk4NzY1NDMyMTAiLCJpYXQiOjE3MzIzMjU1NDQsImV4cCI6MTczMzE4OTU0NCwiYXVkIjoiVVNFUiIsInN1YiI6IkFVVEgifQ.3ZR77-nZ6GrHi8ByqEmbtcWEpPGv3ORoFo6QomYnuhw"
        previousChat.fetchAllFriends { result in
            switch result {
            case .success(_):
                
                let ar = self.previousChat.fetchList
                
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

extension String {
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
