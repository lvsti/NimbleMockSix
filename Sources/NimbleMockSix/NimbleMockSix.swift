//
//  NimbleMockSix.swift
//  NimbleMockSix
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Tamas Lustyik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Nimble
import MockSix


// MARK: - invocation matchers for Nimble:

/// Constructs a matcher that tests the invocation count of the given method
/// of a MockSix mock object.
/// - parameter method: The method to set the expectation for
/// - parameter times: The number of times `method` is expected to be called.
/// - returns: A matcher that passes if `method` is called exactly `times` times, and fails otherwise.
public func receive<T>(_ method: T.MockMethod, times: UInt) -> Predicate<T>
    where T : Mock, T.MockMethod.RawValue == Int {
    
    let message = "receive <\(method)> exactly " + (times == 1 ? "1 time" : "\(times) times")
    return buildReceiveMatcher(message: message,
                               invocationFilter: receiveFilter(for: method.rawValue),
                               countCheck: { $0 == times })
}

/// Constructs a matcher that tests the invocation count of the given method
/// of a MockSix mock object.
/// - parameter method: The method to set the expectation for
/// - parameter times: The minimum number of times `method` is expected to be called. Defaults to 1.
/// - returns: A matcher that passes if `method` is called at least `times` times, and fails otherwise.
public func receive<T>(_ method: T.MockMethod, atLeastTimes times: UInt = 1) -> Predicate<T>
    where T : Mock, T.MockMethod.RawValue == Int {
    
    let message = "receive <\(method)> at least " + (times == 1 ? "1 time" : "\(times) times")
    return buildReceiveMatcher(message: message,
                               invocationFilter: receiveFilter(for: method.rawValue),
                               countCheck: { $0 >= times })
}

/// Constructs a matcher that tests the invocation count of the given method
/// of a MockSix mock object.
/// - parameter method: The method to set the expectation for
/// - parameter times: The maximum number of times `method` is expected to be called.
/// - returns: A matcher that passes if `method` is called at most `times` times, and fails otherwise.
public func receive<T>(_ method: T.MockMethod, atMostTimes times: UInt) -> Predicate<T>
    where T : Mock, T.MockMethod.RawValue == Int {

    let message = "receive <\(method)> at most " + (times == 1 ? "1 time" : "\(times) times")
    return buildReceiveMatcher(message: message,
                               invocationFilter: receiveFilter(for: method.rawValue),
                               countCheck: { $0 <= times })
}


/// Invocation argument verifier type
public typealias ArgVerifier = (_ arg: Any?) -> Bool

/// Constructs a matcher that tests for the invocation arguments of the given method
/// of a MockSix mock object.
/// - parameter method: The method to set the expectation for
/// - parameter times: The number of times `method` is expected to be called with matching arguments.
/// - parameter verifiers: An array of verifiers to apply to the arguments in order
/// - returns: A matcher that passes if there are exactly `times` invocations of `method` for which
///            all the argument verifiers are satisfied; and fails otherwise
public func receive<T>(_ method: T.MockMethod, times: UInt, with verifiers: [ArgVerifier]) -> Predicate<T>
    where T : Mock, T.MockMethod.RawValue == Int {
        
    let message = "receive <\(method)> " + (times == 1 ? "1 time" : "\(times) times") + " with arguments"
    let invocationFilter = receiveWithArgsFilter(for: method.rawValue, verifiers: verifiers)
    return buildReceiveMatcher(message: message,
                               invocationFilter: invocationFilter,
                               countCheck: { $0 == times })
}

/// Constructs a matcher that tests for the invocation arguments of the given method
/// of a MockSix mock object.
/// - parameter method: The method to set the expectation for
/// - parameter times: The minimum number of times `method` is expected to be called
///                    with matching arguments. Defaults to 1.
/// - parameter verifiers: An array of verifiers to apply to the arguments in order
/// - returns: A matcher that passes if there are at least `times` invocations of `method` for which
///            all the argument verifiers are satisfied; and fails otherwise
public func receive<T>(_ method: T.MockMethod, atLeastTimes times: UInt = 1, with verifiers: [ArgVerifier]) -> Predicate<T>
    where T : Mock, T.MockMethod.RawValue == Int {

    let message = "receive <\(method)> at least " + (times == 1 ? "1 time" : "\(times) times") + " with arguments"
    let invocationFilter = receiveWithArgsFilter(for: method.rawValue, verifiers: verifiers)
    return buildReceiveMatcher(message: message,
                               invocationFilter: invocationFilter,
                               countCheck: { $0 >= times })
}

/// Constructs a matcher that tests for the invocation arguments of the given method
/// of a MockSix mock object.
/// - parameter method: The method to set the expectation for
/// - parameter times: The maximum number of times `method` is expected to be called
///                    with matching arguments.
/// - parameter verifiers: An array of verifiers to apply to the arguments in order
/// - returns: A matcher that passes if there are at most `times` invocations of `method` for which
///            all the argument verifiers are satisfied; and fails otherwise
public func receive<T>(_ method: T.MockMethod, atMostTimes times: UInt, with verifiers: [ArgVerifier]) -> Predicate<T>
    where T : Mock, T.MockMethod.RawValue == Int {
        
    let message = "receive <\(method)> at least " + (times == 1 ? "1 time" : "\(times) times") + " with arguments"
    let invocationFilter = receiveWithArgsFilter(for: method.rawValue, verifiers: verifiers)
    return buildReceiveMatcher(message: message,
                               invocationFilter: invocationFilter,
                               countCheck: { $0 <= times })
}


// MARK: - argument verifiers to use with the `receive(_:with:)` matcher

/// Constructs an argument verifier to match a given value
/// - parameter value: The value that the argument is expected to equal to
/// - returns: An argument verifier that passes iff the argument equals to `value`
public func theValue<T : Equatable>(_ value: T) -> ArgVerifier {
    return { x in
        guard let x = x else { return false }
        return x as! T == value
    }
}

/// Constructs an argument verifier to match a nil value
/// - returns: An argument verifier that passes iff the argument is nil
public func nilValue() -> ArgVerifier {
    return { $0 == nil }
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
            return options.contains(where: { $0 == nil })
        }

        let value = x as! T

        return options.contains(where: { $0 != nil && $0! == value })
    }
}

/// Constructs an argument verifier to match any value that passes the given test
/// - parameter test: The predicate that the argument is expected to pass
/// - parameter value: The argument's value to test
/// - returns: An argument verifier that passes if `predicate` evaluates to true
///            for the value of the argument, and fails otherwise
public func any<T>(passing test: @escaping (_ value: T) -> Bool) -> ArgVerifier {
    return { x in
        guard let x = x else { return false }
        return test(x as! T)
    }
}

/// Constructs an argument verifier to match any value that passes the given test
/// - parameter test: The predicate that the argument is expected to pass
/// - parameter value: The argument's value to test
/// - returns: An argument verifier that passes if `predicate` evaluates to true
///            for the value of the argument, and fails otherwise
public func any<T>(passing test: @escaping (_ value: T?) -> Bool) -> ArgVerifier {
    return { x in
        return test(x as! T?)
    }
}


// MARK: - private methods

typealias InvocationFilter = ([MockInvocation]) -> [MockInvocation]

private func buildReceiveMatcher<T>(message: String,
                                    invocationFilter: @escaping InvocationFilter,
                                    countCheck: @escaping (UInt) -> Bool) -> Predicate<T>
    where T : Mock, T.MockMethod.RawValue == Int {
    
    return Predicate.define(message) { actualExpression, msg in
        let actualValue = try actualExpression.evaluate()
        guard let mock = actualValue else {
            return PredicateResult(status: .fail, message: msg.appended(message: "subject is not implementing Mock"))
        }

        let matching = invocationFilter(mock.invocations)
        let success = countCheck(UInt(matching.count))

        return PredicateResult(status: PredicateStatus(bool: success), message: msg.appended(details: message))
    }
}


private func receiveFilter(for methodID: Int) -> InvocationFilter {
    return { invocations in
        invocations.filter { $0.methodID == methodID }
    }
}


private func receiveWithArgsFilter(for methodID: Int, verifiers: [ArgVerifier]) -> InvocationFilter {
    return { invocations in
        invocations
            .filter { $0.methodID == methodID && $0.args.count == verifiers.count }
            .filter { inv in
                for i in 0..<inv.args.count {
                    if !verifiers[i](inv.args[i]) {
                        return false
                    }
                }
                return true
            }
    }
}

