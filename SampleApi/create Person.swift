//
//  create Person.swift
//  SampleApi
//
//  Created by Karthik Rajan T  on 14/08/20.
//  Copyright © 2020 Karthik Rajan T . All rights reserved.
//

import Foundation
struct Person {
    private let homeWorldLink : String
    let birthyear : String
    let gender : String
    let haircolor : String
    let eyecolor : String
    let height : String
    let mass : String
    let name : String
    let skincolor : String
    init?(json : JSON) {
        guard let birthyear = json["birth_year"] as? String,
        let eyecolor = json["eye_color"] as? String,
        let gender = json["gender"] as? String,
        let haircolor = json["hair_color"] as? String,
        let height = json["height"] as? String,
        let homeWorldLink = json["homeworld"] as? String,
        let mass = json["mass"] as? String,
        let name = json["name"] as? String,
        let skincolor = json["skin_color"] as? String
        else { return nil }
        self.homeWorldLink = homeWorldLink
        self.birthyear = birthyear
        self.gender = gender
        self.haircolor = haircolor
        self.eyecolor = eyecolor
        self.height = height
        self.mass = mass
        self.name = name
        self.skincolor = skincolor
    }
    func homeWorld(_ completion: @escaping (String) -> Void)  {
        networkingService.shared.getHomeWorld(homeWorldLink: homeWorldLink){ (homeWorld) in
            completion(homeWorld)
        }
    }
}
