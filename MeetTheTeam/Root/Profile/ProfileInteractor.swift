//
//  ProfileInteractor.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift

protocol ProfileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfilePresentable: Presentable {
    var listener: ProfilePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProfileListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func goBackToList()
    func goBackToRoot()
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable {

    weak var router: ProfileRouting?
    weak var listener: ProfileListener?
    var mode: ProfileBuilder.Mode = .regular

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ProfilePresentable, mode: ProfileBuilder.Mode) {
        super.init(presenter: presenter)
        presenter.listener = self
        self.mode = mode
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}


extension ProfileInteractor: ProfilePresentableListener {
    
    func closeProfile() {
        switch mode {
        case .regular:
            listener?.goBackToList()
        case .experiment:
            listener?.goBackToRoot()
        }
    }
    
}
