//
//  TeamListCollectionViewCell.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/10/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import UIKit

class TeamListCollectionViewCell: UICollectionViewCell {
    
    //UI
    var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "avatar-axolote")
        imageView.layer.backgroundColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 64/2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.customBlue.cgColor
        imageView.layer.borderWidth = 3
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.styleHeader2()
        return label
    }()
    
    var positionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.styleHeader3()
        return label
    }()
    
    var rightArrowImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "rightArrow")
        return imageView
    }()
    
    var separatorView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customLightGray
        return view
    }()
    
    
    private func setupImage(with urlString: String?) {
        guard let imageString = urlString,
            let imageURL = URL(string: imageString) else { return }
        
        avatarImageView.image = #imageLiteral(resourceName: "avatar-axolote")
        let imageService = ImageService()
        imageService.findImage(with: imageURL) { (image) in
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
    
    func setup(teamMember: TeamMember) {
        
        setupImage(with: teamMember.profileImage)
        
        nameLabel.text = teamMember.name
        positionLabel.text = teamMember.position
        
        self.backgroundColor = .white
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(positionLabel)
        addSubview(rightArrowImageView)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 64),
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: rightArrowImageView.leadingAnchor),
            
            positionLabel.heightAnchor.constraint(equalToConstant: 16),
            positionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            positionLabel.trailingAnchor.constraint(equalTo: rightArrowImageView.leadingAnchor),
            
            rightArrowImageView.heightAnchor.constraint(equalToConstant: 13),
            rightArrowImageView.widthAnchor.constraint(equalToConstant: 9),
            rightArrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rightArrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
}

