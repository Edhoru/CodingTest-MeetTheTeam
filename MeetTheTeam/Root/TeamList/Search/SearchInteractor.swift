//
//  SearchInteractor.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift

protocol SearchRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func present(keyWords: [KeyWord])
}

protocol SearchListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func filterList(by word: String)
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable {

    weak var router: SearchRouting?
    weak var listener: SearchListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SearchPresentable) {
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


extension SearchInteractor: SearchPresentableListener {
    
    func filter(by word: String) {
        listener?.filterList(by: word)
    }
    
    func findCommonWords(for team: [TeamMember]) {
        let dataService = DataService()
        dataService.getCommonWords(for: team) { (keyWords) in
            presenter.present(keyWords: keyWords)
        }
    }
}
