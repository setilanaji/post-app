//
//  PostPagePresenter.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import Combine


final class PostPagePresenter: PresenterPostPageProtocol, PresenterToViewPostPageProtocol, ViewToPresenterPostPageProtocol {
    
    weak var input: ViewToPresenterPostPageProtocol? { return self }
    weak var output: PresenterToViewPostPageProtocol? { return self }
    
    var getPosts = PassthroughSubject<Void, Never>()
    var tapAddButton = PassthroughSubject<Void, Never>()
    var viewDidLoadTrigger = PassthroughSubject<Void, Never>()
    var tapUserProfile = PassthroughSubject<UserModel, Never>()

    private let interactor: PresenterToInteractorPostPageProtocol
    private let router: PostPageWireFrame
    
    var posts = CurrentValueSubject<[PostModel], Error>([])
    var usersdummies = CurrentValueSubject<[UserModel], Error>([])
    var activeUser = CurrentValueSubject<UserSessionModel?, Error>(nil)
    
    private var subscriptions = Set<AnyCancellable>()

    init(
        interactor: PresenterToInteractorPostPageProtocol,
        router: PostPageWireFrame
    ) {
        self.interactor = interactor
        self.router = router
        bind()
    }
    
}

private extension PostPagePresenter {
    private func bind() {
        getPosts
            .compactMap({ [weak self] in self?.interactor.getPosts() })
            .flatMap({ $0 })
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.posts.send(completion: .failure(error))
                }
            }, receiveValue: { [weak self] value in
                self?.posts.send(value)
            })
            .store(in: &subscriptions)
        
        tapAddButton
            .sink(receiveValue: { [weak self] in
                guard let session = self?.activeUser.value else {
                    return
                }
                self?.router.toPostFormPage(session: session)
            })
            .store(in: &subscriptions)
        
        tapUserProfile
            .receive(on: DispatchQueue.main)
            .compactMap({ usermodel in
                self.interactor.changeUserSession(from: self.activeUser.value, with: UserSessionModel(user: usermodel))
            })
            .flatMap({ $0 })
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] value in
                print(value)
                self?.activeUser.send(value)
            })
            .store(in: &subscriptions)
        
        viewDidLoadTrigger
            .compactMap({ [weak self] in
                self?.interactor.getUsersData()
            })
            .flatMap({ $0 })
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.usersdummies.send(completion: .failure(error))
                }
            }, receiveValue: { [weak self] value in
                self?.usersdummies.send(value)
            })
            .store(in: &subscriptions)
        
        usersdummies
            .compactMap({ users in
                self.interactor.getUserSession(with: users)
            })
            .flatMap({ $0 })
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.activeUser.send(completion: .failure(error))
                }
            }, receiveValue: { [weak self] value in
                self?.activeUser.send(value)
            })
            .store(in: &subscriptions)
        
    }
}
