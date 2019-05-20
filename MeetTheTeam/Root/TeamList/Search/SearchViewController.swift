//
//  SearchViewController.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol SearchPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func findCommonWords(for team: [TeamMember])
    func filter(by word: String)
}

final class SearchViewController: UIViewController, SearchViewControllable {
    
    //Properties
    weak var listener: SearchPresentableListener?
    private var _team: [TeamMember] = []
    var keyWords: [KeyWord] = []
    var open = false
    
    var team: [TeamMember] {
        get {
            return _team
        }
        set {
            _team = newValue
            listener?.findCommonWords(for: newValue)
        }
    }
    
    //UI
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
    }
    
    func setupProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }
    
}


extension SearchViewController: SearchPresentable {
    
    func present(keyWords: [KeyWord]) {
        self.keyWords = keyWords
    }
}


//Collection view delegates

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return team.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let keyWord = keyWords[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        cell.setup(keyWord: keyWord)
        return cell
    }
}


extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keyWord = keyWords[indexPath.row]
        listener?.filter(by: keyWord.word)
    }
}


extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.bounds.width / 3) - (SearchCollectionViewCell.space * 3)
        return CGSize(width: width, height: SearchCollectionViewCell.height
        )
    }
}

