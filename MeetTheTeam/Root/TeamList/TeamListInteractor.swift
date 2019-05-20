//
//  TeamListInteractor.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift

protocol TeamListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToProfile(for teamMember: TeamMember)
    func routeBackToList()
    func clearChildren(completion: () -> Void)
}

protocol TeamListPresentable: Presentable {
    var listener: TeamListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func show(team: [TeamMember])
    func showFilteredTeam(team: [TeamMember])
}

protocol TeamListListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func dismissList()
}

final class TeamListInteractor: PresentableInteractor<TeamListPresentable> {
    
    weak var router: TeamListRouting?
    weak var listener: TeamListListener?
    
    var fullTeam: [TeamMember] = []
    var filteredTeam: [TeamMember] = []
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TeamListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        let dataService = DataService()
        dataService.getTheTeam { (team, error) in
            fullTeam = team
            presenter.show(team: team)
        }
        
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}


extension TeamListInteractor: TeamListPresentableListener {
    
    func openProfile(for teamMember: TeamMember) {
        router?.routeToProfile(for: teamMember)
    }
    
    func goHome() {
        router?.clearChildren(completion: {
            listener?.dismissList()
        })
    }
}


extension TeamListInteractor: TeamListInteractable {
    
    func filterList(by word: String) {
        let teamWithPosition = fullTeam.filter({ $0.position != nil })
        filteredTeam = teamWithPosition.filter({ $0.position!.contains(word) })
        presenter.showFilteredTeam(team: filteredTeam)
    }
    
    func goBackToList() {
        router?.routeBackToList()
    }
    
    func goBackToRoot() {}
    
}

