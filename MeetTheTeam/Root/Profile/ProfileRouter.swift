//
//  ProfileRouter.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs

protocol ProfileInteractable: Interactable {
    var router: ProfileRouting? { get set }
    var listener: ProfileListener? { get set }
}

protocol ProfileViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileRouter: ViewableRouter<ProfileInteractable, ProfileViewControllable>, ProfileRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileInteractable, viewController: ProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
