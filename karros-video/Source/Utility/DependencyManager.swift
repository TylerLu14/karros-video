//
//  DependencyManager.swift
//  cinemaxxi
//
//  Created by Vu Hoang on 10/31/19.
//  Copyright © 2019 AIOZ. All rights reserved.
//

import Foundation

public typealias RegistrationBlock = (() -> Any)
public typealias GenericRegistrationBlock<T> = (() -> T)

protocol IMutableDependencyResolver {
    func getService(_ type: Any) -> Any?
    func register(_ factory: @escaping RegistrationBlock, type: Any)
}

extension IMutableDependencyResolver {
    
    func getService<T>() -> T {
        return getService(T.self) as! T
    }
    
    func register<T>(_ factory: @escaping GenericRegistrationBlock<T>) {
        return register({ factory() }, type: T.self)
    }
}

class DefaultDependencyResolver: IMutableDependencyResolver {
    
    private var registry = [String: RegistrationBlock]()
    
    func getService(_ type: Any) -> Any? {
        let k = String(describing: type)
        for key in registry.keys {
            if k.contains(key) {
                return registry[key]?()
            }
        }
        return nil
    }
    
    func register(_ factory: @escaping RegistrationBlock, type: Any) {
        let k = String(describing: type)
        registry[k] = factory
    }
}

let dependencyManager = DependencyManager.sharedManager

public class DependencyManager {
    
    public static let sharedManager: DependencyManager = DependencyManager()
    
    private let resolver: IMutableDependencyResolver = DefaultDependencyResolver()
    
    public func getService<T>() -> T {
        return resolver.getService()
    }
    
    public func registerService<T>(_ factory: @escaping GenericRegistrationBlock<T>) {
        resolver.register(factory)
    }
}
