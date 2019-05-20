//
//  TeamMember.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import Foundation

struct TeamMember: Decodable {
    
    enum Sections: String {
        case am
        case like
        case appreciate
    }
    
    let id: String
    let name: String
    let position: String?
    let profileImage: String?
    let personality: String?
    let interests: String?
    let dating_preferences: String?
    
    /* This is the dreaded failable initializer, although it is questioned by some, it actually provides us with a very simple way to verify if an object should be considered valid. (way simpler than extending the Codable protocols)
     In this case an object without id or without a name is not considered valid, this configuration can be adapted to any need that we have. */
    init?(with dictionary: [String: AnyObject]) {
        guard let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.position = dictionary["position"] as? String
        self.profileImage = dictionary["profile_image"] as? String
        self.personality = dictionary["personality"] as? String
        self.interests = dictionary["interests"] as? String
        self.dating_preferences = dictionary["dating_preferences"] as? String
    }
    
    func getContent(for section: Sections) -> String? {
        switch section {
        case .am:
            return self.personality
        case .like:
            return self.interests
        case .appreciate:
            return self.dating_preferences
        }
    }
}
