//
//  UserHeaderView.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/24.
//

import UIKit
import Combine

public class UserHeaderView: NiblessView {
    
    var presenter: PresenterPostPageProtocol
    
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let title: UILabel = {
        let text = UILabel()
        text.font = .boldSystemFont(ofSize: 16)
        text.textColor = .label
        text.text = "Post App"
        return text
    }()
    
    let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiaryLabel
        return view
    }()
    
    private lazy var avatar: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 18
        view.backgroundColor = .cyan
        view.isUserInteractionEnabled = true
        
        view.addSubview(avatarImage)
        view.addSubview(menuButton)
        NSLayoutConstraint.activate([
            avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            avatarImage.heightAnchor.constraint(equalTo: view.heightAnchor),
            avatarImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            menuButton.heightAnchor.constraint(equalTo: view.heightAnchor),
            menuButton.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }()
    
    init(
        frame: CGRect = .zero,
        presenter: PresenterPostPageProtocol
    ) {
        self.presenter = presenter
        super.init(frame: frame)
        backgroundColor = .clear
        
        constructHirearchy()
        activateConstraints()
        
        bind()
    }
    
    private func constructHirearchy() {
        [title, avatar, bottomLine].forEach { view in
            addSubview(view)
            view.isUserInteractionEnabled = true
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            avatar.heightAnchor.constraint(equalToConstant: 36),
            avatar.widthAnchor.constraint(equalToConstant: 36),
            avatar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            avatar.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setMenuButton(with data: [UserModel]) {
        menuButton.menu = UIMenu(title: "Select account", children:
                                    data.compactMap { value -> UIAction in
            
            return UIAction(title: value.username, image: UIImage(named: value.avatar), state:  presenter.output?.activeUser.value?.user == value ? .on : .off , handler: {_ in
                self.presenter.input?.tapUserProfile.send(value)
            })
        }
        )
    }
    
}

private extension UserHeaderView {
    private func bind() {
        presenter.output?.activeUser
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] value in
                guard let user = value else {
                    return
                }
                self?.setMenuButton(with: self?.presenter.output?.usersdummies.value ?? [])
                self?.avatarImage.image = UIImage(named: user.user.avatar)
            })
            .store(in: &subscriptions)
        
        presenter.output?.usersdummies
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] value in
                self?.setMenuButton(with: value)
            })
            .store(in: &subscriptions)
    }
}
