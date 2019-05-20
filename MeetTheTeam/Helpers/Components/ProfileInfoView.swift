//
//  ProfileInfoView.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import UIKit

class ProfileInfoView: UIView {

    //UI
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.styleHeader2()
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.styleBody1()
        return label
    }()
    
    init(teamMember: TeamMember, section: TeamMember.Sections) {
        super.init(frame: .zero)
        
        guard let detailsText = teamMember.getContent(for: section) else {
            self.isHidden = true
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "I \(section.rawValue)..."
        detailsLabel.text = detailsText
        
        addSubview(titleLabel)
        addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            detailsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
