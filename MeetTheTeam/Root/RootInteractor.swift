//
//  RootInteractor.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift

enum AppExperience {
    case regular
    case experiment
}


protocol RootRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func launchRegularExperience()
    func launchExperimentExperience(for teamMember: TeamMember)
    func routeBack()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable> {
    
    weak var router: RootRouting?
    weak var listener: RootListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
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


extension RootInteractor: RootPresentableListener {
    
    func select(experience: AppExperience) {
        switch experience {
        case .regular:
            router?.launchRegularExperience()
        case .experiment:
            let dataService = DataService()
            dataService.getRandomTeamMember { (teamMember) in
                guard let validTeamMember = teamMember else { return }
                
                self.router?.launchExperimentExperience(for: validTeamMember)
            }
        }
    }
    
}


extension RootInteractor: RootInteractable {
    
    func goBackToRoot() {
        router?.routeBack()
    }    
    
    func goBackToList() {}
    
    
    func dismissList() {
        router?.routeBack()
    }
}

