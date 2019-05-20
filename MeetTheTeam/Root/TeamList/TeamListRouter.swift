//
//  TeamListRouter.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs

protocol TeamListInteractable: Interactable, ProfileListener, SearchListener {
    var router: TeamListRouting? { get set }
    var listener: TeamListListener? { get set }
}

protocol TeamListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func push(viewController: ViewControllable, for teamMember: TeamMember)
    func addSearch(viewController: ViewControllable)
}

final class TeamListRouter: ViewableRouter<TeamListInteractable, TeamListViewControllable> {

    private let profileBuilder: ProfileBuildable
    private let searchBuilder: SearchBuildable
    private var currentChild: ViewableRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: TeamListInteractable,
         viewController: TeamListViewControllable,
         profileBuilder: ProfileBuildable,
         searchBuilder: SearchBuildable) {
    
        self.profileBuilder = profileBuilder
        self.searchBuilder = searchBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
        
        includeSearch()
    }
    
    func includeSearch() {
        let search = searchBuilder.build(withListener: interactor)
        attachChild(search)
        viewController.addSearch(viewController: search.viewControllable)
    }
}


extension TeamListRouter: TeamListRouting {
    
    func routeToProfile(for teamMember: TeamMember) {
        let profile = profileBuilder.build(withListener: interactor, teamMember: teamMember, mode: .regular)
        self.currentChild = profile
        attachChild(profile)
        viewController.push(viewController: profile.viewControllable, for: teamMember)
    }
    
    func routeBackToList() {
        //We don't need to dismiss the view controller here because it was already dismissed with it's own back button
        if let currentChild = currentChild {
            detachChild(currentChild)
            self.currentChild = nil
        }
    }
    
    func clearChildren(completion: () -> Void) {
        for child in self.children {
            detachChild(child)
        }
        currentChild = nil
        
        completion()
    }
    
}
