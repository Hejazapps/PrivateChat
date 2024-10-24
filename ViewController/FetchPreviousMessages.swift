
//  Untitled.swift
//  iNwe
//
//  Created by Sadiqul Amin on 24/7/24.
//

// LoginViewModel.swift

import Foundation

class FetchPreviousMessages {
    
    var currentPage: Int = 1
    var authorizationKey: String = ""
    var shouldFetch = true
    var fetchList = [Message]()
    var chatId = ""
    var limit = 10
    
    
    func fetchAllFriends(completion: @escaping (Result<Response1, Error>) -> Void) {
        guard let apiUrl = URL(string: "https://devapi.heywow.app/api/chat/\(chatId)?page=\(currentPage)&limit=\(limit)") else {
            print("Invalid URL")
            return
        }
       
        print("api url \(apiUrl)")
        
        
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
                let decoder = JSONDecoder()
                
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> {
                    
                    print("data \(convertedJsonIntoDict)")
                }
                
                let userProfile = try decoder.decode(Response1.self, from: data)
                
                if let chatData = userProfile.data {
                    
                    if chatData.count < 10 {
                        self.shouldFetch = false
                    }
                    for chat in chatData {
                        self.fetchList.append(chat)
                    }
                    self.currentPage = self.currentPage + 1
                    print("data i found \(self.fetchList)")
                } else {
                    print("No chat data available.")
                }
                
                completion(.success(userProfile))
            } catch {
                // Print the error for debugging
                print("Error decoding JSON: \(error.localizedDescription)")
                
                // Optionally, print the raw data to help identify issues
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON data: \(jsonString)")
                }
                self.shouldFetch = false
                completion(.failure(error))
            }
        }.resume()
    }
    
    
}

