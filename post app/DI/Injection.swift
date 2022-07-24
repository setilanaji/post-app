//
//  Injection.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation
import RealmSwift

public final class Injection: NSObject {
    static public func providePostPageInteractor(realm: Realm) -> PresenterToInteractorPostPageProtocol {
        let coder = UserSessionPropertyListCoder()
        let userStore = UserDataStoreDiskUserPrefs()
        let userSessionStore = KeychainUserSessionDataStore(userSessionCoder: coder)
        let local = PostLocalDataSource(realm: realm)
        let userMapper = UserMapper()
        let postMapper = PostMapper(userMapper: userMapper)
        let dataMapper = PostsMapper(postMapper: postMapper)
        
        let getPosts = GetPostsRepository(
            mapper: dataMapper,
            local: local)
        
        let getUsersData = GetUsersDataRepository(store: userStore)
        let updateUsersData = UpdateUsersDataRepository(store: userStore)
        let getUserSession = GetUserSessionRepository(store: userSessionStore)
        let saveUserSession = SaveUserSessionRepository(store: userSessionStore)
        let deleteUserSession = DeleteUserSessionRepository(store: userSessionStore)
        
        return PostPageInteractor(
            getPostsRepository: getPosts,
            getUsersDataRepository: getUsersData,
            updateUsersDataRepository: updateUsersData,
            getUserSessionRepository: getUserSession,
            saveUserSessionRepository: saveUserSession,
            deleteUserSessionRepository: deleteUserSession
        ) as PresenterToInteractorPostPageProtocol
    }
    
    static public func providePostFormPageInteractor(realm: Realm) -> PresenterToInteractorPostFormPageProtocol {
        let local = PostLocalDataSource(realm: realm)
        let userMapper = UserMapper()
        let dataMapper = PostMapper(userMapper: userMapper)
        let addPostRepository = AddPostRepository(
            mapper: dataMapper,
            local: local)
        
        return PostFormPageInteractor(addPostRepository: addPostRepository) as PresenterToInteractorPostFormPageProtocol
    }
}
