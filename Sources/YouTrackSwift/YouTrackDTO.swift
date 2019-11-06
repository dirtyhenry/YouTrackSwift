import Foundation

public struct Agile: Codable {
    public let name: String
    public let id: String
}

public struct Sprint: Codable {
    public let name: String
    public let id: String
}

public struct DetailedSprint: Codable {
    public struct IssueLite: Codable {
        public let summary: String?
        public let idReadable: String
        public let id: String
    }

    public let issues: [IssueLite]
    public let name: String
    public let id: String
}

public struct Issue {
    public let summary: String
    public let id: String
    
    public let assignee: String?
    public let storyPoints: Int?
    
    enum CodingKeys: String, CodingKey {
        case summary
        case id
        case customFields
    }
}

extension Issue: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        summary = try values.decode(String.self, forKey: .summary)
        
        var fetchedAssignee: String? = nil
        var fetchedStoryPoints: Int? = nil
        if case let .array(allCustomFields) = try values.decode(JSON.self, forKey: .customFields) {
            allCustomFields.forEach { customField in
                if case let .dictionary(customFieldAsDict) = customField {
                    guard case let .string(customFieldName) = customFieldAsDict["name"] else {
                        return
                    }
                    
                    switch customFieldName {
                    case "Assignee":
                        if case let .dictionary(valueDict) = customFieldAsDict["value"],
                            case let .string(assigneeValue) = valueDict["name"] {
                            fetchedAssignee = assigneeValue
                        } else {
                            return
                        }
                    case "Story points":
                        if case let .double(storyPointsValue) = customFieldAsDict["value"] {
                            fetchedStoryPoints = Int(storyPointsValue)
                        } else {
                            return
                        }
                    default:
                        debugPrint("Ignoring \(customFieldName)")
                    }
                }
            }
        }

        assignee = fetchedAssignee
        storyPoints = fetchedStoryPoints
    }
}
