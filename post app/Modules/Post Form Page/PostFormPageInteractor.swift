//
//  PostFormPageInteractor.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/23.
//

import Foundation
import Combine

public class PostFormPageInteractor<
    AddPostRepository: Repository
>: PresenterToInteractorPostFormPageProtocol
where
AddPostRepository.Request == PostModel,
AddPostRepository.Response == Bool
{
        
    private let addPostRepository: AddPostRepository
    private let backgroundQueque = DispatchQueue(label: "PostFormPageQueque", qos: .background)
        
    required init(
        addPostRepository: AddPostRepository
    ) {
        self.addPostRepository = addPostRepository
    }
    
    public func addPost(with data: PostModel) -> AnyPublisher<Bool, Error> {
        return self.addPostRepository.excecute(request: data)
            .receive(on: backgroundQueque)
            .eraseToAnyPublisher()
    }
}
