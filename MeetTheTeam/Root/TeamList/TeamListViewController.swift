//
//  TeamListViewController.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol TeamListPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func openProfile(for teamMember: TeamMember)
    func goHome()
}

final class TeamListViewController: UIViewController {

    //Properties
    weak var listener: TeamListPresentableListener?
    var team: [TeamMember] = []
    var searchViewController: SearchViewController?
    
    //UI
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TeamListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var searchContainer: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    var searchContainerHeightConstraint: NSLayoutConstraint?
    var searchContainerBottomConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setupProperties() {
        self.title = "Meet The Team"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.barTintColor = .customBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.rewind,
                                         target: self,
                                         action: #selector(tapOnHome))
        leftButton.tintColor = .white
        self.navigationController?.topViewController?.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search,
                                          target: self,
                                          action: #selector(tapOnFilter))
        rightButton.tintColor = .white
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = rightButton
        
        self.view.addSubview(searchContainer)
        self.view.addSubview(collectionView)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchContainer.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            searchContainer.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            
            
            collectionView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
        
        searchContainerHeightConstraint = searchContainer.heightAnchor.constraint(equalToConstant: 0)
        searchContainerHeightConstraint?.isActive = true
        
        searchContainerBottomConstraint = searchContainer.bottomAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 0)
        searchContainerBottomConstraint?.isActive = true
    }
    
    @objc func tapOnFilter() {
        guard let searchVC = searchViewController else { return }
        
        var height: CGFloat
        if searchVC.open == true {
            height = 0
        } else {
            height = CGFloat(searchVC.keyWords.count) / 3 * SearchCollectionViewCell.height
            searchContainerHeightConstraint?.constant = height
        }
        searchVC.open = !searchVC.open
        
        searchContainerBottomConstraint?.constant = height
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func tapOnHome() {
        for subview in searchContainer.subviews {
            subview.removeFromSuperview()
        }
        searchViewController = nil
        
        listener?.goHome()
    }
    
}


//MARK: RIBs extensions

extension TeamListViewController: TeamListPresentable {
    
    func show(team: [TeamMember]) {
        self.team = team
        collectionView.reloadData()
        
        //This is an example of the communication with childrens after they are created, we kept a reference of them
        searchViewController?.team = team
    }
    
    func showFilteredTeam(team: [TeamMember]) {
        self.team = team
        collectionView.reloadData()
        tapOnFilter()
    }
    
}

extension TeamListViewController: TeamListViewControllable {
    
    func addSearch(viewController: ViewControllable) {
        guard let searchVC = viewController.uiviewController as? SearchViewController else { fatalError("we didn't get a search vc") }
        
        self.searchViewController = searchVC
        searchVC.view.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchVC.view)
        
        NSLayoutConstraint.activate([
            searchVC.view.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            searchVC.view.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor),
            searchVC.view.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor),
            searchVC.view.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor)
        ])
    }
    
    func push(viewController: ViewControllable, for teamMember: TeamMember) {
        guard let profileVC = viewController.uiviewController as? ProfileViewController else { return }
        self.navigationController?.pushViewController(profileVC, animated: true)
    }    
    
}


//MARK: Collection view extensions

extension TeamListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return team.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let teamMember = team[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TeamListCollectionViewCell
        cell.setup(teamMember: teamMember)
        return cell
    }
}


extension TeamListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let teamMember = team[indexPath.row]
        listener?.openProfile(for: teamMember)
    }
}


extension TeamListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 83)
    }
}
