//
//  Untitled.swift
//  iNwe
//
//  Created by Sadiqul Amin on 24/7/24.
//

// LoginViewModel.swift

import Foundation

class FetchAllFriendsChat {
    
    var currentPage: Int = 0
    var authorizationKey: String = ""
    var shouldFetch = true
    var currentOnlineFriends = [Friend]()
    
    
    
    func fetchAllFriends(completion: @escaping (Result<FriendsProfile, Error>) -> Void) {
        let urlString = "https://devapi.heywow.app/api/chat?page=1&limit=10"
        
        guard let apiUrl = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authorizationKey)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 1, userInfo: nil)))
                return
            }
            
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let ar = json["data"] as? NSArray {
                        for item in ar {
                            
                        }
                    }
                }
            } catch {
                
            }
            
            
            
            do {
                let decoder = JSONDecoder()
                
                let userProfile = try decoder.decode(FriendsProfile.self, from: data)
                
                if userProfile.friends.count > 0 {
                    
                    self.currentPage = self.currentPage + 1
                    self.shouldFetch = true
                }
                else {
                    self.shouldFetch = false
                }
                
                
                completion(.success(userProfile))
            } catch {
                self.shouldFetch = false
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}

