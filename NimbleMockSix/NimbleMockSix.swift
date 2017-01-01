//
//  NimbleMockSix.h
//  NimbleMockSix
//
//  Created by Tamas Lustyik on 2017. 01. 01..
//  Copyright © 2017. Tamas Lustyik. All rights reserved.
//

import Foundation

import Nimble
import MockSix


// MARK: - invocation matchers for Nimble:

public func receive<T>(_ method: T.MockMethod, times: Int = 1) -> MatcherFunc<T?>
    where T : Mock, T.MockMethod.RawValue == Int {
    
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "receive <\(method)> " + (times == 1 ? "1 time" : "\(times) times")
        guard
            let doublyWrappedMock = try? actualExpression.evaluate(),
            let wrappedMock = doublyWrappedMock,
            let mock = wrappedMock
        else {
            fatalError("mock is not implementing Mock")
        }

        return mock.invocations.filter { $0.methodID == method.rawValue }.count == times
    }
}

public typealias ArgVerifier = (Any?) -> Bool

public func receive<T>(_ method: T.MockMethod, with verifiers: [ArgVerifier]) -> MatcherFunc<T?>
    where T : Mock, T.MockMethod.RawValue == Int {
    
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "receive <\(method)> with arguments"
        guard
            let doublyWrappedMock = try? actualExpression.evaluate(),
            let wrappedMock = doublyWrappedMock,
            let mock = wrappedMock
        else {
            fatalError("mock is not implementing Mock")
        }

        let matching = mock.invocations
            .filter { $0.methodID == method.rawValue && $0.args.count == verifiers.count }
            .filter { inv in
                for i in 0..<inv.args.count {
                    if !verifiers[i](inv.args[i]) {
                        return false
                    }
                }
                return true
            }
        return matching.count == 1
    }
}

// MARK: - argument verifiers to use with the `receive` matcher

/// argument matches the given value
public func theValue<T : Equatable>(_ val: T?) -> ArgVerifier {
    return { x in
        guard let x = x else {
            return val == nil
        }
        
        guard let val = val else {
            return false
        }
        
        return x as! T == val
    }
}

/// argument matches anything (always succeeds)
public func any() -> ArgVerifier {
    return { _ in true }
}

/// argument matches any of the values in the array
public func any<T : Equatable>(of options: [T?]) -> ArgVerifier {
    return { x in
        guard let x = x else {
            return options.index(where: { $0 == nil }) != nil
        }
        
        return options.index(where: { $0 != nil && $0! == x as! T }) != nil
    }
}

/// argument makes the predicate true
public func any<T>(passing test: @escaping (T) -> Bool) -> ArgVerifier {
    return { x in
        test(x as! T)
    }
}

/// argument makes the predicate true
public func any<T>(passing test: @escaping (T?) -> Bool) -> ArgVerifier {
    return { x in
        test(x as! T?)
    }
}

