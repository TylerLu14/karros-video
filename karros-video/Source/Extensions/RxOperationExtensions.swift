//
//  RxOperationExtensions.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    
    public var value: Wrapped? {
        return self
    }
}

public extension ObservableType where Element: OptionalType {
    
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else { return .empty() }
            return .just(value)
        }
    }
}

public extension SharedSequenceConvertibleType where Element: OptionalType {
    
    func filterNil() -> SharedSequence<SharingStrategy,Element.Wrapped> {
        return flatMap { element -> SharedSequence<SharingStrategy,Element.Wrapped> in
            guard let value = element.value else { return .empty() }
            return .just(value)
        }
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait, Element: OptionalType {
    func filterNil() -> Single<Element.Wrapped> {
        flatMap{ element in
            guard let value = element.value else { return .never() }
            return .just(value)
        }
    }
}
