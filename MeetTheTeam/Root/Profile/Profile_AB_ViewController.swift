//
//  Profile_AB_ViewController.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import Lottie

protocol Profile_AB_PresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func closeProfile()
}

final class Profile_AB_ViewController: UIViewController, ProfilePresentable, ProfileViewControllable {
    
    //Properties
    weak var listener: ProfilePresentableListener?
    var teamMember: TeamMember
    var open = false
    
    //UI
    let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let animationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "arrowVertical")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopAnimation = false
        animationView.animationSpeed = 3.0
        return animationView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.addTarget(self, action: #selector(tappCloseButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
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
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.styleHeader1()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.styleHeader2()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var scrollViewBottomToContainer: NSLayoutConstraint?
    var containerViewHeightConstraint: NSLayoutConstraint?
    
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Since the viewcontroller is removed through the back button here we inform it's listener and eventually it's parent that 'Profile' needs to be removed as current children
        listener?.closeProfile()
    }
    
    func setupProperties() {
        let names = teamMember.name.components(separatedBy: " ")
        self.title = names.first ?? ""
        
        nameLabel.text = teamMember.name
        positionLabel.text = teamMember.position
        setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = true
        
        let actionTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappActionButton(_:)))
        animationView.addGestureRecognizer(actionTapGesture)
        
        setupImage(with: teamMember.profileImage)
        
        self.view.addSubview(photoImageView)
        self.view.addSubview(containerView)
        self.view.addSubview(animationView)
        self.view.addSubview(closeButton)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(positionLabel)
        containerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
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
            photoImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            
            animationView.heightAnchor.constraint(equalToConstant: 44),
            animationView.widthAnchor.constraint(equalToConstant: 44),
            animationView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20),
            animationView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20),
            closeButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 70),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -70),
            nameLabel.heightAnchor.constraint(equalToConstant: 64),
            
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 70),
            positionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -70),
            positionLabel.heightAnchor.constraint(equalToConstant: 24),
            
            scrollView.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor), //we use the container view and not the scrollview because otherwise it will go out of bounds
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        
        //Individual constrains for animation
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 128)//UIScreen.main.bounds.height * 0.15)
        containerViewHeightConstraint?.isActive = true
        
        scrollViewBottomToContainer = scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        scrollViewBottomToContainer?.isActive = true
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


//MARK: Button actions
extension Profile_AB_ViewController {
    
    @objc func tappActionButton(_ sender: UIButton) {
        containerViewHeightConstraint?.constant = open == false ? UIScreen.main.bounds.height * 0.75 : 128
        scrollViewBottomToContainer?.constant = open == false ? -44 : 0
        
        self.animateArrow()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutSubviews()
        })
    }
    
    @objc func tappCloseButton(_ sender: UIButton) {
        listener?.closeProfile()
    }
    
    func animateArrow() {
        if open == false {
            animationView.play(fromFrame: 0, toFrame: 8, withCompletion: nil)
        } else {
            animationView.play(fromFrame: 8, toFrame: 16, withCompletion: nil)
        }
        
        self.open = !self.open
    }
    
}
