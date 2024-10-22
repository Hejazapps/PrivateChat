//
//  Decode.swift
//  PrivateChat
//
//  Created by Sadiqul Amin on 22/10/24.
//

struct FriendsProfile: Codable {
    let success: Bool
    let friends: [Friend]
}


struct Friend: Codable {
    let id: Int
    let username: String?
    let gender: String?
    let country: String?
    let statusMessage: String?
    let profilePicture: ProfilePicture
    let level: Int?
    let appearance: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case gender
        case country
        case statusMessage = "status_message"
        case profilePicture = "profile_picture"
        case level
        case appearance
        
    }
    
}


struct ProfilePicture: Codable {
    let url: String?
    let thumb:Small
    let small:Small
}


struct Small: Codable {
    let url: String?
}
