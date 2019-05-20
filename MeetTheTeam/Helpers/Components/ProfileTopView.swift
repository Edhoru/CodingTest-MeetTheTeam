//
//  ProfileTopView.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import UIKit

class ProfileTopView: UIView {
    
    //Properties
    let inclineOffset: CGFloat = 5
    
    //UI
    let inclinedView1: InclinedView = {
        let inclinedView = InclinedView(frame: .zero)
        inclinedView.translatesAutoresizingMaskIntoConstraints = false
        inclinedView.color = .customBlue
        inclinedView.backgroundColor = .clear
        return inclinedView
    }()
    
    let inclinedView2: InclinedView = {
        let inclinedView = InclinedView(frame: .zero)
        inclinedView.translatesAutoresizingMaskIntoConstraints = false
        inclinedView.backgroundColor = .clear
        return inclinedView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.styleHeader1()
        return label
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.styleHeader2()
        return label
    }()
    
    var name: String {
        get {
            return nameLabel.text ?? ""
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    var position: String? {
        get {
            return positionLabel.text ?? ""
        }
        set {
            positionLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(inclinedView1)
        addSubview(inclinedView2)
        addSubview(nameLabel)
        addSubview(positionLabel)
        
        NSLayoutConstraint.activate([
            inclinedView1.topAnchor.constraint(equalTo: self.topAnchor),
            inclinedView1.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inclinedView1.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inclinedView1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            inclinedView2.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            inclinedView2.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inclinedView2.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inclinedView2.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3 * 2),
            
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            positionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            positionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            positionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

