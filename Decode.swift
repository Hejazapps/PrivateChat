
struct Response: Codable {
    let isError: Bool? // Adjusted to Bool for clarity
    let data: ChatData?
}

struct ChatData: Codable {
    let filteredChats: [Chat]?
}

struct Chat: Codable {
    let v: Int?
    let id: String?
    let createdAt: String?
    let updatedAt: String?
    let lastMessageAt: String?
    let lastMessageStatus: String?
    let unreadMessageCount: [String: Int]? // Assuming it's a dictionary
    let members: [Member]
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case createdAt
        case updatedAt
        case lastMessageAt
        case lastMessageStatus
        case unreadMessageCount
        case members
    }
}

struct Member: Codable {
    let id: String?
    let accountName: String?
    let avatar: Avatar?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case accountName
        case avatar
    }
}

struct Avatar: Codable {
    let id: String?
    let src: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case src
    }
}


struct Message: Codable {
    let id: String
    let chat: String
    let createdAt: String
    let files: [File]
    let message: String
    let sender: String
    let status: MessageStatus

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case chat
        case createdAt
        case files
        case message
        case sender
        case status
    }
}

// MARK: - File
struct File: Codable {
    // Define file properties here if needed
}

// MARK: - MessageStatus
enum MessageStatus: String, Codable {
    case sent = "SENT"
    // Add other statuses if necessary
}

// MARK: - Response
struct Response1: Codable {
    let data: [Message]?
}

// MARK
