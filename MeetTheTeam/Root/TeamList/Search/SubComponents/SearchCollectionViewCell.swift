//
//  SearchCollectionViewCell.swift
//  MeetTheTeam
//
//  Created by Alberto Huerdo on 1/11/19.
//  Copyright © 2019 huerdo. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    //properties
    static let height: CGFloat = 42
    static let space: CGFloat = 8
    
    //UI
    var keyWordLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.styleHeader3()
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .customBlue
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.sizeToFit()
        return label
    }()
    
    func setup(keyWord: KeyWord) {
        keyWordLabel.text = keyWord.word
        
        self.backgroundColor = .white
        
        addSubview(keyWordLabel)
        
        NSLayoutConstraint.activate([
            keyWordLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: SearchCollectionViewCell.space / 2),
            keyWordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: SearchCollectionViewCell.space / 2),
            keyWordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: SearchCollectionViewCell.space / -2),
            keyWordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: SearchCollectionViewCell.space / -2)
        ])
    }
    
}
