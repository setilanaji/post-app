//
//  PostPageViewRoo.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import UIKit
import Combine

public class PostPageViewRoot: NiblessView {
    
    var hirearchyNotReady = true
    let presenter: PresenterPostPageProtocol
    
    private var posts: [PostModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    lazy var collectionView: UICollectionView = {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: listLayout)
        
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(PostViewCell.self, forCellWithReuseIdentifier: PostViewCell.identifier)
        
        return collectionView
    }()
    
    let emptyText: UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 14)
        text.textColor = .secondaryLabel
        text.text = "Add new post by pressing \"+\" button"
        return text
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapAddButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerView: UserHeaderView = {
        let header = UserHeaderView(presenter: self.presenter)
        return header
    }()
    
    init(
        frame: CGRect = .zero,
        presenter: PresenterPostPageProtocol
    ) {
        self.presenter = presenter
        super.init(frame: frame)
    }
    
    public override func didMoveToWindow() {
        guard hirearchyNotReady else {
            return
        }
        
        backgroundColor = .systemBackground
        
        constructHirearchy()
        activateConstraints()
        hirearchyNotReady = false
        
        bind()
    }
    
    private func constructHirearchy() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        [headerView, collectionView, addButton, emptyText].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 64),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 48),
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            emptyText.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyText.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    @objc
    private func tapAddButton(_ sender: Any) {
        presenter.input?.tapAddButton.send()
    }
}

// MARK: CollectionView

extension PostPageViewRoot {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self.createPostLayout()
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func createPostLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 1)
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return layoutSection
    }
}

extension PostPageViewRoot: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostViewCell.identifier, for: indexPath) as? PostViewCell else {
            return UICollectionViewCell()
        }
        
        let post = posts[indexPath.row]
        
        cell.setContentWith(post: post)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension PostPageViewRoot: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

private extension PostPageViewRoot {
    func bind() {
        presenter.output?.posts
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("\(error)")
                }
            }, receiveValue: { [weak self] value in
                self?.emptyText.isHidden = !value.isEmpty
                self?.posts = value
            })
            .store(in: &subscriptions)
    }
}
