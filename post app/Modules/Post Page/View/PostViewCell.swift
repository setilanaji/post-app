//
//  PostView.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit

class PostViewCell: NiblessCollectionViewCell {
    static let identifier = "PostViewCell"
    
    private var insertedImageHeightConstraint: NSLayoutConstraint?
    
    let postedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.isHidden = true
        return imageView
    }()
    
    let postedText: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let userAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    let username: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        constructHirearchy()
        activateConstraints()
    }
    
    func constructHirearchy() {
        [userAvatar, name, username, postedText, postedImage].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    func activateConstraints() {
        insertedImageHeightConstraint = postedImage.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            userAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            userAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userAvatar.heightAnchor.constraint(equalToConstant: 32),
            userAvatar.widthAnchor.constraint(equalToConstant: 32),
            
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: userAvatar.trailingAnchor, constant: 8),
            
            username.centerYAnchor.constraint(equalTo: name.centerYAnchor),
            username.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 5),
            username.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
            postedText.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            postedText.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            postedText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            postedImage.topAnchor.constraint(equalTo: postedText.bottomAnchor, constant: 8),
            postedImage.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            postedImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            postedImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            insertedImageHeightConstraint!
        ])
    }
    
    func showInsertedImage(with image: UIImage) {
        postedImage.image = image
        postedImage.isHidden = false
        insertedImageHeightConstraint?.constant = 200
    }
}

extension PostViewCell {
    func setContentWith(post data: PostModel) {
        self.name.text = data.creator.name
        self.username.text = "@\(data.creator.username)"
        self.postedText.text = data.text
        self.userAvatar.image = UIImage(named: data.creator.avatar)
    
        if data.hasPhoto {
            if let image = data.photoImage {
                showInsertedImage(with: image)
            }
        } else {
            postedImage.isHidden = true
            insertedImageHeightConstraint?.constant = 0
        }
    }
}
