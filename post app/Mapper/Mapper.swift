//
//  Mapper.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/22.
//

import Foundation

public protocol LocalMapper {
    associatedtype Entity
    associatedtype Domain
    
    func transformEntityToDomain(entity: Entity) -> Domain
    func transformDomainToEntity(domain: Domain) -> Entity
}

public protocol Mapper: LocalMapper {}
