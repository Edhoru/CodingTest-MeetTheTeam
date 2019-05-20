//
//  TeamListBuilder.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs

protocol TeamListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TeamListComponent: Component<TeamListDependency>, ProfileDependency, SearchDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TeamListBuildable: Buildable {
    func build(withListener listener: TeamListListener) -> TeamListRouting
}

final class TeamListBuilder: Builder<TeamListDependency>, TeamListBuildable {

    override init(dependency: TeamListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TeamListListener) -> TeamListRouting {
        let component = TeamListComponent(dependency: dependency)
        let viewController = TeamListViewController()
        let interactor = TeamListInteractor(presenter: viewController)
        interactor.listener = listener
        
        let profileBuilder = ProfileBuilder(dependency: component)
        let searchBuilder = SearchBuilder(dependency: component)
        
        return TeamListRouter(interactor: interactor,
                              viewController: viewController,
                              profileBuilder: profileBuilder,
                              searchBuilder: searchBuilder)
    }
}
