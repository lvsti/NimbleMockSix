# NimbleMockSix

[![](https://api.travis-ci.org/lvsti/NimbleMockSix.svg?branch=master)](https://travis-ci.org/lvsti/NimbleMockSix)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/NimbleMockSix.svg)](https://cocoapods.org/pods/NimbleMockSix)
![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20OS%20X%20%7C%20tvOS%20%7C%20Linux-lightgrey.svg)

[Nimble](https://github.com/Quick/Nimble) matchers for [MockSix](https://github.com/lvsti/MockSix).

### Teaser

With NimbleMockSix, you can easily make expectations on method invocations on MockSix mock objects. Suppose you have the following mock already in place (for details, see the [MockSix documentation](https://github.com/lvsti/MockSix)):

```swift
// original interface to mock
protocol MyClassProtocol {
    func myFunc(string: String, number: Double) -> [Int]
}

// original implementation
class MyClass: MyClassProtocol {
    func myFunc(string: String, number: Double) -> [Int] {
        // ... whatever ...
        return [1, 2, 3]
    }
}

// mock implementation
class MockMyClass: MyClassProtocol, Mock {
    enum Methods: Int {
        case myFunc
    }    
    typealias MockMethod = Methods
    
    func myFunc(string: String, number: Double) -> [Int] {
        return registerInvocation(for: .myFunc, 
                                  args: string, number 
                                  andReturn: [])
    }
}
```

To test for the invocation count of a method:

```swift
// given
let myMock = MockMyClass()
myMock.stub(.myFunc, andReturn: [42])

// when
myMock.myFunc(string: "aaa", number: 3.14)
myMock.myFunc(string: "bbb", number: 6.28)
    
// then
expect(myMock).to(receive(.myFunc, times: 2))   // --> passes
```

To test the arguments of an invocation:

```swift
// given
let myMock = MockMyClass()
myMock.stub(.myFunc, andReturn: [42])

// when
myMock.myFunc(string: "aaa", number: 3.14)

expect(myMock).to(receive(.myFunc, with: [
    theValue("aaa"), 
    any()
]))    // --> passes

expect(myMock).to(receive(.myFunc, with: [
    any(of: ["bbb", "ccc"]), 
    any { x in x >= 3.0 && x < 4.0 }
]))    // --> fails
```

But there is more!

Currently implemented matchers:

- just invocation count constraints: `receive(_:times:)`, `receive(_:atLeastTimes:)`, `receive(_:atMostTimes:)`
- invocation count AND argument constraints: `receive(_:times:with:)`, `receive(_:atLeastTimes:with:)`, `receive(_:atMostTimes:with:)`: 

Currently implemented argument verifiers:

- `theValue(_:)`: argument matches the given value
- `nilValue()`: argument is nil
- `any()`: argument matches anything (always passes)
- `any(of:)`: argument matches any of the values in the array
- `any(passing:)`: argument makes the predicate true

### Requirements

To build: Swift 3.+ <br/>
To use: macOS 10.10+, iOS 8.4+, tvOS 9.2+

### Installation

Via Cocoapods: add the following line to your Podfile:

```
pod 'NimbleMockSix'
```

Via Carthage: add the following lines to your Cartfile (or Cartfile.private):

```
github "lvsti/NimbleMockSix"
github "Quick/Quick"
```

Via the Swift Package Manager: add it to the dependencies in your Package.swift:

```swift
let package = Package(
    name: "MyAwesomeApp",
    dependencies: [
        .Package(url: "https://github.com/lvsti/NimbleMockSix", majorVersion: 0),
        .Package(url: "https://github.com/Quick/Quick", majorVersion: 1),
        // ... other dependencies ...
    ]
)
```

### License

NimbleMockSix is released under the MIT license.
