//
//  DataService.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import Foundation

struct Photo {
    let url: URL
}

struct Endpoint {
    let method: String = HTTPMethod.get.rawValue
    let path = "https://uifaces.co/api?limit=10&emotion[]=happiness"
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
}

class DataService {
    
    func getTheTeam(completion: (_ team: [TeamMember], _ error: Error?) -> Void) {
        guard let path = Bundle.main.path(forResource: "team", ofType: "json") else {
            fatalError("no file")
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let team = mapTeam(from: data)
            completion(team, nil)
        } catch {
            fatalError("error")
        }
    }
    
    func mapTeam(from data: Data) -> [TeamMember] {
        do {
            //In a perfect world with perfect API's this is all we have to do
            let team = try JSONDecoder().decode([TeamMember].self, from: data)
            return team
        } catch {
            //Since the team data wasn't decodable by default, we need to check and decode each element of the array
            //If the element is valid (it has to include id and name) we will return it
            do {
                let teamJSON = try JSONSerialization.jsonObject(with: data,
                                                                options: [])
                guard let teamArray = teamJSON as? [[String : AnyObject]] else {
                    // Since jsonResponse it's not an array we return an emtpy array
                    return []
                }
                
                var team: [TeamMember] = []
                for member in teamArray {
                    if let teamMember = TeamMember(with: member) {
                        team.append(teamMember)
                    } else {
                        print("member with incomplete info: ", member)
                    }
                }
                return team
            } catch let parsingError {
                print("Error", parsingError)
                return []
            }
        }
    }
    
    func getCommonWords(for team: [TeamMember], completion: ([KeyWord]) -> Void) {
        let positionsOptional = team.map({ $0.position?.components(separatedBy: " ") }).compactMap({ $0 })
        let positions = positionsOptional.reduce([], +)
        let positionsDictionary = Dictionary(grouping: positions, by: { $0 })
        
        let keyWords = positionsDictionary.map { KeyWord(word: $0.key, count: $0.value.count) }
            .sorted(by: { $0.count > $1.count })
        
        completion(keyWords)
    }
    
    func getRandomTeamMember(completion: (_ TeamMember: TeamMember?) -> Void) {
        self.getTheTeam { (team, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            
             let randomNumber = arc4random_uniform(UInt32(team.count))
            let teamMember = team[Int(randomNumber)]
            completion(teamMember)
        }
    }
}


extension DataService {
    
    //If we want to print the json data we just add this line 'printJSON(from: data)' below 'let data' in getTheTeam()
    private func printJSON(from data: Data) {
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data, options: [])
            print(jsonResponse)
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
}



