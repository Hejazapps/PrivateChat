//
//  Untitled.swift
//  iNwe
//
//  Created by Sadiqul Amin on 24/7/24.
//

// LoginViewModel.swift

import Foundation

class FetchAllFriendsChat {
    
    var currentPage: Int = 1
    var authorizationKey: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NzNmMDY3Y2Q2NTc2YTZhNDgzNTY0NDQiLCJyb2xlIjoiVVNFUiIsImFjY291bnROYW1lIjoiYWFyYXZfMDkxIiwiZW1haWwiOiJ0ZXN0dXNlcjFAZ21haWwuY29tIiwiZW1haWxWZXJpZmllZCI6dHJ1ZSwiYWNjb3VudElkIjoxLCJwaG9uZU51bWJlciI6Ijk4NzY1NDMyMTAiLCJpYXQiOjE3MzIzMjU1NDQsImV4cCI6MTczMzE4OTU0NCwiYXVkIjoiVVNFUiIsInN1YiI6IkFVVEgifQ.3ZR77-nZ6GrHi8ByqEmbtcWEpPGv3ORoFo6QomYnuhw"
    var shouldFetch = true
    var fetchList = [Chat]()
    
    
    
    func fetchAllFriends(completion: @escaping (Result<Response, Error>) -> Void) {
        let urlString = "https://devapi.heywow.app/api/chat?page=\(currentPage)&limit=10"
        print("urlstring \(urlString)")
        
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
                let decoder = JSONDecoder()
                
             
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> {
                    
                    print("hello data \(convertedJsonIntoDict)")
                }
                
                
                let userProfile = try decoder.decode(Response.self, from: data)
                
                if let chatData = userProfile.data, let filteredChats = chatData.chats {
                    
                    if filteredChats.count < 10 {
                        self.shouldFetch = false
                    }
                    for chat in filteredChats {
                        self.fetchList.append(chat)
                    }
                    print("data i found \(self.fetchList.count)")
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

