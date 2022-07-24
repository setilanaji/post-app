//
//  ImageForm.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/24.
//

import UIKit

protocol ImageViewCellDelegate {
    func removeImage()
}

public class ImageForm: NiblessTableViewCell {
    static let identifier = "ImageFormCell"
    
    private var insertedImageHeightConstraint: NSLayoutConstraint?
    
    var delegate: ImageViewCellDelegate?
    
    private lazy var insertedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var deleteButton: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "xmark.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal))
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.deleteImage(_:))))
        imageView.backgroundColor = .systemFill
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    public override init(
        style: UITableViewCell.CellStyle = .default,
        reuseIdentifier: String? = "NiblessTableViewCell"
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
        constructHirearchy()
        activateConstraints()
    }
    
    private func constructHirearchy() {
        [insertedImage, deleteButton].forEach{
            $0.isUserInteractionEnabled = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func activateConstraints() {
        insertedImageHeightConstraint = insertedImage.heightAnchor.constraint(equalToConstant: 48)
        
        NSLayoutConstraint.activate([
            insertedImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            insertedImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            insertedImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            insertedImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            insertedImageHeightConstraint!,
            insertedImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            
            deleteButton.topAnchor.constraint(equalTo: insertedImage.topAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: insertedImage.trailingAnchor, constant: -10),
            deleteButton.heightAnchor.constraint(equalToConstant: 32),
            deleteButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc
    private func deleteImage(_ sender: Any) {
        delegate?.removeImage()
    }
    
}

extension ImageForm {
    public func setImage(with image: UIImage?) {
        insertedImage.image = image
        
        if let image = image {
            let ratio = image.size.width / image.size.height
            let newHeight = insertedImage.frame.width / ratio
            insertedImageHeightConstraint?.constant = newHeight
        }
        
        insertedImage.isHidden = image == nil
        deleteButton.isHidden = image == nil
    }
}
