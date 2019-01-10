//
//  TeamMember.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import Foundation

struct TeamMember: Decodable {
    
    let id: String
    let name: String
    let position: String
    let profile_image: String
    let personality: String
    let interests: String
    let dating_preferences: String
}
