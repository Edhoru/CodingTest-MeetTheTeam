//
//  AppComponent.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs

class AppComponent: Component<EmptyComponent>, RootDependency {
    
    init() {
        super.init(dependency: EmptyComponent())
    }
}
