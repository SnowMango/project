
class ChatMessage: Codable {
    enum Role: String, Codable {
        case assistant
        case user
    }
    var role: Role = .user
    var content: String
    var roundCount: Int?
    
    init(role: Role, content: String, roundCount: Int? = nil) {
        self.role = role
        self.content = content
        self.roundCount = roundCount
    }
}
