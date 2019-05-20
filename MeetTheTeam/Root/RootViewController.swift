//
//  RootViewController.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import Lottie

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func select(experience: AppExperience)
}

final class RootViewController: UIViewController, RootPresentable {
    
    //Properties
    weak var listener: RootPresentableListener?
    
    //UI
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Alberto"
        label.styleHeader0()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "iOS Candidate"
        label.styleHeader1()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let taskButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Regular version", for: .normal)
        button.backgroundColor = .customBlue
        button.addTarget(self, action: #selector(experienceChosen(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 52 / 2
        return button
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The app with for the task given with an extra filter to show a RIB working from a subview."
        label.numberOfLines = 0
        label.styleBody2()
        label.textAlignment = .justified
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let experimentButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Experiment version", for: .normal)
        button.backgroundColor = .customBlue
        button.addTarget(self, action: #selector(experienceChosen(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 52 / 2
        return button
    }()
    
    let experimentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Something extra to show how the elements of a RIB can be reused to provide a different experience just by using another view controller when presenting a random profile."
        label.numberOfLines = 0
        label.styleBody2()
        label.textAlignment = .justified
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let animationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "coffee_and_biscuit")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopAnimation = true
        return animationView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        animationView.pause()
    }
    
    func setupProperties() {
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        self.view.addSubview(animationView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(taskLabel)
        self.view.addSubview(taskButton)
        self.view.addSubview(experimentLabel)
        self.view.addSubview(experimentButton)
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            
            taskLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 60),
            taskLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -60),
            taskLabel.bottomAnchor.constraint(equalTo: taskButton.topAnchor, constant: -10),
            
            taskButton.bottomAnchor.constraint(equalTo: layoutGuide.centerYAnchor, constant: -40),
            taskButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 60),
            taskButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -60),
            taskButton.heightAnchor.constraint(equalToConstant: 52),
            
            experimentLabel.topAnchor.constraint(equalTo: taskButton.bottomAnchor, constant: 20),
            experimentLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 60),
            experimentLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -60),
            experimentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 80), //We give a minimun size to the experiments label so the text isn't too small on smaller phones (iPhone 8)
            
            experimentButton.topAnchor.constraint(equalTo: experimentLabel.bottomAnchor, constant: 10),
            experimentButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 60),
            experimentButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -60),
            experimentButton.heightAnchor.constraint(equalToConstant: 52),
            
            animationView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
            animationView.topAnchor.constraint(greaterThanOrEqualTo: experimentButton.bottomAnchor),
            animationView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width / 1.5),
            animationView.widthAnchor.constraint(equalTo: animationView.heightAnchor),
            animationView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
    }
    
}

//MARK: Button actions
extension RootViewController {
    
    @objc func experienceChosen(_ sender: UIButton) {
        if sender == taskButton {
            listener?.select(experience: .regular)
        } else if sender == experimentButton {
            listener?.select(experience: .experiment)
        }
    }
    
}


extension RootViewController: RootViewControllable {
    
    func present(viewController: ViewControllable) {
        let navigationController = UINavigationController(rootViewController: viewController.uiviewController)
        present(navigationController, animated: true)
    }
    
    func dismiss(viewController: ViewControllable) {
        if let navController = presentedViewController as? UINavigationController {
            if navController.viewControllers.first === viewController.uiviewController {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
