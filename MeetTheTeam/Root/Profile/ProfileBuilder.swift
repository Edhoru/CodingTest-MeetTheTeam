//
//  ProfileBuilder.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs

protocol ProfileDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProfileComponent: Component<ProfileDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProfileBuildable: Buildable {
    func build(withListener listener: ProfileListener, teamMember: TeamMember, mode: ProfileBuilder.Mode) -> ProfileRouting
}

final class ProfileBuilder: Builder<ProfileDependency>, ProfileBuildable {
    
    enum Mode {
        case regular
        case experiment
    }

    override init(dependency: ProfileDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileListener, teamMember: TeamMember, mode: Mode) -> ProfileRouting {
        //we disable the next line because Profile doesn't have children
//        let component = ProfileComponent(dependency: dependency)
        
        //Here is the change, based on the mode we can swap view controllers
        //This is extra useful for A/B testing
        var viewController: ProfilePresentable & ProfileViewControllable
        switch mode {
        case .regular:
            viewController = ProfileViewController(teamMember: teamMember)
        case .experiment:
            viewController = Profile_AB_ViewController(teamMember: teamMember)
        }
        
        let interactor = ProfileInteractor(presenter: viewController, mode: mode)
        interactor.listener = listener
        return ProfileRouter(interactor: interactor, viewController: viewController)
    }
}
