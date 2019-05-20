//
//  ProfileViewController.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ProfilePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func closeProfile()
}

final class ProfileViewController: UIViewController, ProfilePresentable, ProfileViewControllable {
    
    //Properties
    weak var listener: ProfilePresentableListener?
    var teamMember: TeamMember
    
    //UI
    let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    let profileTopView: ProfileTopView = {
        let profileTopView = ProfileTopView(frame: .zero)
        profileTopView.translatesAutoresizingMaskIntoConstraints = false
        profileTopView.backgroundColor = .clear
        return profileTopView
    }()
    
    let containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let contentView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    
    var photoBottomConstraint: NSLayoutConstraint?
    var photoHeightConstraint: NSLayoutConstraint?
    
    
    init(teamMember: TeamMember) {
        self.teamMember = teamMember
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Since the viewcontroller is removed through the back button here we inform it's listener and eventually it's parent that 'Profile' needs to be removed as current children
        listener?.closeProfile()
    }
    
    func setupProperties() {
        let names = teamMember.name.components(separatedBy: " ")
        self.title = names.first ?? ""
        
        profileTopView.name = teamMember.name
        profileTopView.position = teamMember.position
        
        scrollView.delegate = self
        
        setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.tintColor = .white
        
        setupImage(with: teamMember.profileImage)
        
        self.view.addSubview(photoImageView)
        self.view.addSubview(scrollView)
        scrollView.addSubview(profileTopView)
        scrollView.addSubview(containerView)
        containerView.addSubview(contentView)
        
        //setup views inside the stack view
        let personalityView = ProfileInfoView(teamMember: self.teamMember, section: .am)
        contentView.addArrangedSubview(personalityView)
        
        let preferencesView = ProfileInfoView(teamMember: self.teamMember, section: .like)
        contentView.addArrangedSubview(preferencesView)
        
        let interestsView = ProfileInfoView(teamMember: self.teamMember, section: .appreciate)
        contentView.addArrangedSubview(interestsView)
        
        //Setup constraints
        let layoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: -30), //This -30 seems odd, but is the offset you can see in the design
            photoImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            
            profileTopView.heightAnchor.constraint(equalToConstant: 150),
            profileTopView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor),
            profileTopView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: UIScreen.main.bounds.width - 30 - 95),
            profileTopView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            profileTopView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: profileTopView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            ])
        
        //Individual constrains for animation
        photoBottomConstraint = photoImageView.bottomAnchor.constraint(equalTo: profileTopView.topAnchor, constant: 100)
        photoBottomConstraint?.isActive = true
        photoHeightConstraint = photoImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        photoHeightConstraint?.isActive = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    private func setupImage(with urlString: String?) {
        guard let imageString = urlString,
            let imageURL = URL(string: imageString) else { return }
        
        photoImageView.image = #imageLiteral(resourceName: "avatar-axolote")
        
        let imageService = ImageService()
        imageService.findImage(with: imageURL) { (image) in
            DispatchQueue.main.async {
                self.photoImageView.image = image
            }
        }
    }
}


extension ProfileViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /* In the design pdf you can see the avatar image is static, that caused the problem that when scrolling down you see an empty space.
         in the current setup the avatar moves with the scrollview becoming bigger or smaller.
         To increase the size of the avatar only when pulling down and leave it static when going up just uncomment the next three lines
        */
//        let distance = scrollView.contentOffset.y
//        photoBottomConstraint?.isActive = distance < 0
//        photoHeightConstraint?.isActive = distance >= 0
    }
}

