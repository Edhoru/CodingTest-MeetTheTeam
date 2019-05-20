//
//  RootRouter.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, TeamListListener,ProfileListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable> {
    
    private let teamListBuilder: TeamListBuildable
    private let profileBuilder: ProfileBuildable
    
    private var currentChild: ViewableRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         teamListBuilder: TeamListBuildable,
         profileBuilder: ProfileBuildable) {
        
        self.teamListBuilder = teamListBuilder
        self.profileBuilder = profileBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}


extension RootRouter: RootRouting {
    
    func launchRegularExperience() {
        let teamList = teamListBuilder.build(withListener: interactor)
        attachChild(teamList)
        currentChild = teamList
        viewController.present(viewController: teamList.viewControllable)
    }
    
    func launchExperimentExperience(for teamMember: TeamMember) {
        let profile = profileBuilder.build(withListener: interactor, teamMember: teamMember, mode: .experiment)
        attachChild(profile)
        currentChild = profile
        viewController.present(viewController: profile.viewControllable)
    }
    
    func routeBack() {
        if let currentChild = currentChild {
            detachChild(currentChild)
            viewController.dismiss(viewController: currentChild.viewControllable)
            self.currentChild = nil
        }
    }
    
}

