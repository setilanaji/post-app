//
//  PostFormPagePresenter.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import UIKit
import Combine

final class PostFormPagePresenter: PresenterPostFormPageProtocol, PresenterToViewPostFormPageProtocol, ViewToPresenterPostFormPageProtocol {

    
    weak var input: ViewToPresenterPostFormPageProtocol? { return self }
    weak var output: PresenterToViewPostFormPageProtocol? { return self }
    
    var tapSaveButton = PassthroughSubject<PostModel, Never>()

    private let interactor: PresenterToInteractorPostFormPageProtocol
    private let router: PostFormPageWireFrame
    
    private var subscriptions = Set<AnyCancellable>()
    var postToAdd = CurrentValueSubject<PostModel?, Error>(nil)

    init(
        interactor: PresenterToInteractorPostFormPageProtocol,
        router: PostFormPageWireFrame
    ) {
        self.interactor = interactor
        self.router = router
        bind()
    }
    
}

private extension PostFormPagePresenter {
    private func bind() {
        tapSaveButton
            .compactMap({ [weak self] data in
                self?.interactor.addPost(with: data)
            })
            .flatMap({ $0 })
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] value in
                DispatchQueue.main.async {
                    if value {
                        self?.router.closePage()
                    }
                }
            })
            .store(in: &subscriptions)
        
    }
}
