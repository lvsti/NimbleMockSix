//
//  NimbleMockSix.h
//  NimbleMockSix
//
//  Created by Tamas Lustyik on 2017. 01. 01..
//  Copyright © 2017. Tamas Lustyik. All rights reserved.
//

import Nimble
import MockSix


// MARK: - invocation matchers for Nimble:

/// Constructs a matcher that tests for the invocation count of the given method
/// of a MockSix mock object.
/// - parameter method: The method to set the expectation for
/// - parameter times: The number of times `method` is expected to be called
/// - returns: A matcher that passes if `method` is called exactly `times` times, and fails otherwise.
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

/// Invocation argument verifier type
public typealias ArgVerifier = (_ arg: Any?) -> Bool

/// Constructs a matcher that tests for the invocation arguments of the given method
/// of a MockSix mock object.
/// - parameter method: The method to set the expectation for
/// - parameter verifiers: An array of verifiers to apply to the arguments in order
/// - returns: A matcher that passes if there is exactly 1 invocation of `method` that 
///            satisfies all the argument verifiers, and fails otherwise
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

// MARK: - argument verifiers to use with the `receive(_:with:)` matcher

/// Constructs an argument verifier to match a given value
/// - parameter value: The value that the argument is expected to equal to
/// - returns: An argument verifier that passes iff the argument equals to `value`
public func theValue<T : Equatable>(_ value: T?) -> ArgVerifier {
    return { x in
        guard let x = x else {
            return value == nil
        }
        
        guard let value = value else {
            return false
        }
        
        return x as! T == value
    }
}

/// Constructs an argument verifier that always succeeds
/// - returns: An argument verifier that always succeeds
public func any() -> ArgVerifier {
    return { _ in true }
}

/// Constructs an argument verifier to match any value from the given array
/// - parameter options: The array of values that the argument is expected to take its value from
/// - returns: An argument verifier that passes if the argument equals to any value 
///            in `options`, and fails otherwise
public func any<T : Equatable>(of options: [T?]) -> ArgVerifier {
    return { x in
        guard let x = x else {
            return options.index(where: { $0 == nil }) != nil
        }
        
        return options.index(where: { $0 != nil && $0! == x as! T }) != nil
    }
}

/// Constructs an argument verifier to match any value that passes the given test
/// - parameter test: The predicate that the argument is expected to pass
/// - parameter value: The argument's value to test
/// - returns: An argument verifier that passes if `predicate` evaluates to true
///            for the value of the argument, and fails otherwise
public func any<T>(passing test: @escaping (_ value: T) -> Bool) -> ArgVerifier {
    return { x in
        test(x as! T)
    }
}

/// Constructs an argument verifier to match any value that passes the given test
/// - parameter test: The predicate that the argument is expected to pass
/// - parameter value: The argument's value to test
/// - returns: An argument verifier that passes if `predicate` evaluates to true
///            for the value of the argument, and fails otherwise
public func any<T>(passing test: @escaping (_ value: T?) -> Bool) -> ArgVerifier {
    return { x in
        test(x as! T?)
    }
}

