//
//  RecentlyChatVc.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 8/10/24.
//

import UIKit

class RecentlyChatVc: UIViewController {
    
    let gap:CGFloat = 10
    @IBOutlet weak var frequentlyChattedCollectionView: UICollectionView!
    
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUi()
        self.registerXib()
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
    
    func registerXib () {
        
        let nib = UINib(nibName: "ProfileCell", bundle: .main)
        frequentlyChattedCollectionView.register(nib, forCellWithReuseIdentifier: "ProfileCell")
        
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


extension RecentlyChatVc: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the item width based on the collection view's width and desired number of items per row
        
        
        return CGSize(width: 60, height: 60)  // Adjust height if needed
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: gap, left: 0, bottom: gap, right: gap)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return gap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return gap
    }
}


extension RecentlyChatVc: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        
        
        
        
        return cell
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
        
        
        return  20
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        cell.selectionStyle = .none
        
        let attributedString = NSMutableAttributedString()
        
        // Title attributes
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        let titleAttributedString = NSAttributedString(string: "Hello i am an looser!", attributes: titleAttributes)
        
        // Add title to the attributed string
        attributedString.append(titleAttributedString)
        
        // Append newline character
        attributedString.append(NSAttributedString(string: "\n"))
        
        // Subtitle attributes
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let subtitleAttributedString = NSAttributedString(string: "But i am an expert in UKIT", attributes: subtitleAttributes)
        
        // Add subtitle to the attributed string
        attributedString.append(subtitleAttributedString)
        
        // Assign the attributed string to the label
        cell.detailLabel.attributedText = attributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  90
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
}

