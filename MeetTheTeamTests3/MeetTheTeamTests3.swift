//
//  MeetTheTeamTests3.swift
//  MeetTheTeamTests3
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import XCTest

class MeetTheTeamTests3: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let testDictionaryIncomplete = ["id" : "this is the id",
                                   "name" : "this is the name"] as [String : AnyObject]
    
    
    let testDictionaryEmpty = [:] as [String : AnyObject]
    
    
    let testDictionaryValid = ["id" : "this is the id",
                               "name" : "this is the name",
                               "position" : "this is the position",
                               "profile_image" : "this is the profile_image",
                               "personality" : "this is the personality",
                               "interests" : "this are the interests",
                               "dating_preferences" : "this are the dating_preferences"] as [String : AnyObject]
    
    func testContentNil() {
        let testMember = TeamMember(with: testDictionaryIncomplete)
        let description = testMember?.getContent(for: .am)
        XCTAssertEqual(description, nil)
    }
    
    func testContentValid() {
        let testMember = TeamMember(with: testDictionaryValid)
        
        let iAm = testMember?.getContent(for: .am)
        XCTAssertEqual(iAm, testMember?.personality)
        
        let iLike = testMember?.getContent(for: .like)
        XCTAssertEqual(iLike, testMember?.interests)
        
        let iAppreciate = testMember?.getContent(for: .appreciate)
        XCTAssertEqual(iAppreciate, testMember?.dating_preferences)
    }
    
    func testTeamMemberNil() {
        //First we check with a good dictionary and remove the value for id
        var testDicationaryWithouId = testDictionaryValid
        if let value = testDicationaryWithouId.removeValue(forKey: "id") {
            print("The value \(value) was removed.")
        }
        
        let testMember = TeamMember(with: testDicationaryWithouId)
        XCTAssertNil(testMember)
        
        
        let testMemberEmpty = TeamMember(with: testDictionaryEmpty)
        XCTAssertNil(testMemberEmpty)
    }
    
    func testTeamMemberIncompleteNoNil() {
        let testMember = TeamMember(with: testDictionaryIncomplete)
        XCTAssertNotNil(testMember)
        
        XCTAssertNil(testMember?.interests)
    }

}
