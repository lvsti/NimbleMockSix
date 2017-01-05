//
//  NimbleMockSixTests.swift
//  NimbleMockSixTests
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

import Quick
import Nimble
import MockSix
import NimbleMockSix

class MockDummy: Mock {
    enum Methods: Int {
        case myFunc
        case myOtherFunc
    }
    typealias MockMethod = Methods
    
    init() {
    }
}

class NimbleMockSixSpec: QuickSpec {
    
    override func spec() {
        let dummy = MockDummy()
        
        beforeEach {
            dummy.resetMock()
        }

        describe("receive with exact count") {
            
            it("passes for the exact invocation count") {
                // given
                dummy.registerInvocation(for: .myFunc)
                dummy.registerInvocation(for: .myFunc)
                
                // then
                expect(dummy).to(receive(.myFunc, times: 2))
            }
            
            it("fails for less invocations") {
                // given
                dummy.registerInvocation(for: .myFunc)

                // then
                expect(dummy).toNot(receive(.myFunc, times: 2))
            }
            
            it("fails for more invocations") {
                // given
                dummy.registerInvocation(for: .myFunc)
                dummy.registerInvocation(for: .myFunc)
                dummy.registerInvocation(for: .myFunc)
                
                // then
                expect(dummy).toNot(receive(.myFunc, times: 2))
            }

            it("is not affected by other invocations") {
                // given
                dummy.registerInvocation(for: .myFunc)
                dummy.registerInvocation(for: .myOtherFunc)
                dummy.registerInvocation(for: .myOtherFunc)
                dummy.registerInvocation(for: .myFunc)
                
                // then
                expect(dummy).to(receive(.myFunc, times: 2))
            }
            
        }
        
        describe("receive at least N times") {
            
            context("minimum count is not specified") {
                it("passes for 1 invocation") {
                    // given
                    dummy.registerInvocation(for: .myFunc)
                    
                    // then
                    expect(dummy).to(receive(.myFunc))
                }
                
                it("fails for no invocations") {
                    // then
                    expect(dummy).toNot(receive(.myFunc))
                }
                
                it("passes for more invocations") {
                    // given
                    dummy.registerInvocation(for: .myFunc)
                    dummy.registerInvocation(for: .myFunc)
                    dummy.registerInvocation(for: .myFunc)
                    
                    // then
                    expect(dummy).to(receive(.myFunc))
                }
            }
            
            context("minimum count is specified") {
                it("passes for the minimum count") {
                    // given
                    dummy.registerInvocation(for: .myFunc)
                    dummy.registerInvocation(for: .myFunc)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, atLeastTimes: 2))
                }
                
                it("fails for less invocations") {
                    // given
                    dummy.registerInvocation(for: .myFunc)

                    // then
                    expect(dummy).toNot(receive(.myFunc, atLeastTimes: 2))
                }
                
                it("passes for more invocations") {
                    // given
                    dummy.registerInvocation(for: .myFunc)
                    dummy.registerInvocation(for: .myFunc)
                    dummy.registerInvocation(for: .myFunc)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, atLeastTimes: 2))
                }

                it("still fails independently of other invocations") {
                    // given
                    dummy.registerInvocation(for: .myOtherFunc)
                    dummy.registerInvocation(for: .myOtherFunc)
                    dummy.registerInvocation(for: .myFunc)
                    
                    // then
                    expect(dummy).toNot(receive(.myFunc, atLeastTimes: 2))
                }
            }

        }

        describe("receive at most N times") {
            
            it("passes for the maximum count") {
                // given
                dummy.registerInvocation(for: .myFunc)
                dummy.registerInvocation(for: .myFunc)
                
                // then
                expect(dummy).to(receive(.myFunc, atMostTimes: 2))
            }
            
            it("fails for more invocations") {
                // given
                dummy.registerInvocation(for: .myFunc)
                dummy.registerInvocation(for: .myFunc)
                dummy.registerInvocation(for: .myFunc)
                
                // then
                expect(dummy).toNot(receive(.myFunc, atMostTimes: 2))
            }
            
            it("passes for less invocations") {
                // given
                dummy.registerInvocation(for: .myFunc)
                
                // then
                expect(dummy).to(receive(.myFunc, atMostTimes: 2))
            }
            
            it("still passes independently of other invocations") {
                // given
                dummy.registerInvocation(for: .myOtherFunc)
                dummy.registerInvocation(for: .myOtherFunc)
                dummy.registerInvocation(for: .myFunc)
                
                // then
                expect(dummy).to(receive(.myFunc, atMostTimes: 2))
            }
            
        }

        describe("receive with args verification with exact count") {
            
            let verifiers = [
                { (x: Any?) in x as? String == "foo" },
                { (x: Any?) in x as? Int == 42 },
            ]
            
            it("passes for the exact invocation count") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).to(receive(.myFunc, times: 2, with: verifiers))
            }
            
            it("fails for less invocations") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).toNot(receive(.myFunc, times: 2, with: verifiers))
            }
            
            it("fails for more invocations") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).toNot(receive(.myFunc, times: 2, with: verifiers))
            }
            
            it("is not affected by other invocations") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myOtherFunc)
                dummy.registerInvocation(for: .myOtherFunc)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).to(receive(.myFunc, times: 2, with: verifiers))
            }
            
            it("fails for the exact invocation count if any argument verification fails") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 0)
                
                // then
                expect(dummy).toNot(receive(.myFunc, times: 2, with: verifiers))
            }

            it("passes for more invocations if only the exact count passes the verification") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 0)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).to(receive(.myFunc, times: 2, with: verifiers))
            }
        }
        
        describe("receive with args verification at least N times") {
            
            let verifiers = [
                { (x: Any?) in x as? String == "foo" },
                { (x: Any?) in x as? Int == 42 },
            ]

            context("minimum count is not specified") {
                it("passes for 1 invocation") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, with: verifiers))
                }
                
                it("fails for no invocations") {
                    // then
                    expect(dummy).toNot(receive(.myFunc, with: verifiers))
                }
                
                it("passes for more invocations") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, with: verifiers))
                }

                it("still fails independently of other invocations") {
                    // given
                    dummy.registerInvocation(for: .myOtherFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).toNot(receive(.myFunc, with: verifiers))
                }
                
                it("still passes independently of other invocations") {
                    // given
                    dummy.registerInvocation(for: .myOtherFunc, args: "bar", 0)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, with: verifiers))
                }
                
                it("fails for 1 invocation if any argument verification fails") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 0)
                    
                    // then
                    expect(dummy).toNot(receive(.myFunc, with: verifiers))
                }
                
                it("fails for more invocations if argument verification fails for all of them") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "bar", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 0)
                    dummy.registerInvocation(for: .myFunc, args: "bar", 0)
                    
                    // then
                    expect(dummy).toNot(receive(.myFunc, with: verifiers))
                }
            }
            
            context("minimum count is specified") {
                it("passes for the minimum count") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, atLeastTimes: 2, with: verifiers))
                }
                
                it("fails for less invocations") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).toNot(receive(.myFunc, atLeastTimes: 2, with: verifiers))
                }
                
                it("passes for more invocations") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, atLeastTimes: 2, with: verifiers))
                }
                
                it("still fails independently of other invocations") {
                    // given
                    dummy.registerInvocation(for: .myOtherFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myOtherFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).toNot(receive(.myFunc, atLeastTimes: 2, with: verifiers))
                }
                
                it("still passes independently of other invocations") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myOtherFunc, args: "bar", 42)
                    dummy.registerInvocation(for: .myOtherFunc, args: "foo", 0)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, atLeastTimes: 2, with: verifiers))
                }
                
                it("fails for the minimum count if any argument verification fails") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 0)
                    
                    // then
                    expect(dummy).toNot(receive(.myFunc, atLeastTimes: 2, with: verifiers))
                }

                it("fails for more invocations if argument verification passes for less than the minimum count") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 0)
                    dummy.registerInvocation(for: .myFunc, args: "bar", 42)
                    
                    // then
                    expect(dummy).toNot(receive(.myFunc, atLeastTimes: 2, with: verifiers))
                }

                it("passes for more invocations if argument verification passes for at least the minimum count") {
                    // given
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 0)
                    dummy.registerInvocation(for: .myFunc, args: "bar", 42)
                    dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                    dummy.registerInvocation(for: .myFunc, args: "bar", 0)
                    
                    // then
                    expect(dummy).to(receive(.myFunc, atLeastTimes: 2, with: verifiers))
                }
            }
            
        }
        
        describe("receive with args verification at most N times") {
            
            let verifiers = [
                { (x: Any?) in x as? String == "foo" },
                { (x: Any?) in x as? Int == 42 },
            ]

            it("passes for the maximum count") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).to(receive(.myFunc, atMostTimes: 2, with: verifiers))
            }
            
            it("fails for more invocations") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).toNot(receive(.myFunc, atMostTimes: 2, with: verifiers))
            }
            
            it("passes for less invocations") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).to(receive(.myFunc, atMostTimes: 2, with: verifiers))
            }
            
            it("still passes independently of other invocations") {
                // given
                dummy.registerInvocation(for: .myOtherFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myOtherFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).to(receive(.myFunc, atMostTimes: 2, with: verifiers))
            }
            
            it("passes for more invocations if argument verification passes for at most the maximum count") {
                // given
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 0)
                dummy.registerInvocation(for: .myFunc, args: "bar", 42)
                dummy.registerInvocation(for: .myFunc, args: "foo", 42)
                
                // then
                expect(dummy).to(receive(.myFunc, atMostTimes: 2, with: verifiers))
            }
        }
        
        describe("argument verifiers") {
            
            describe("theValue") {
                it("matches the given value") {
                    // when
                    let verifier = theValue(42)
                    
                    // then
                    expect(verifier(42)) == true
                }
                
                it("doesn't match any other value") {
                    // when
                    let verifier = theValue(42)
                    
                    // then
                    expect(verifier(3.14)) == false
                }

                it("doesn't match nil") {
                    // when
                    let verifier = theValue(42)
                    
                    // then
                    expect(verifier(nil)) == false
                }
            }
            
            describe("any") {
                it("matches arbitrary values") {
                    // when
                    let verifier = any()
                    
                    // then
                    expect(verifier("foobar")) == true
                    expect(verifier(42)) == true
                }
                
                it("matches nil") {
                    // when
                    let verifier = any()
                    
                    // then
                    expect(verifier(nil)) == true
                }
            }
            
            describe("any of") {
                it("can match the first option") {
                    // when
                    let verifier = any(of: [0, 1, 1, 2, 3, 5, 8, 13])
                    
                    // then
                    expect(verifier(0)) == true
                }

                it("can match the last option") {
                    // when
                    let verifier = any(of: [0, 1, 1, 2, 3, 5, 8, 13])
                    
                    // then
                    expect(verifier(13)) == true
                }
                
                it("can match multiple options") {
                    // when
                    let verifier = any(of: [0, 1, 1, 2, 3, 5, 8, 13])
                    
                    // then
                    expect(verifier(1)) == true
                }

                it("can match nil") {
                    // when
                    let verifier = any(of: [2, 3, nil, 5, nil, 7])
                    
                    // then
                    expect(verifier(nil)) == true
                }

                it("doesn't match any other value") {
                    // when
                    let verifier = any(of: [0, 1, 1, 2, 3, 5, 8, 13])
                    
                    // then
                    expect(verifier(4)) == false
                }
            }
            
            describe("any passing test") {
                it("matches if the test passes") {
                    // when
                    let verifier = any { (s: String) in s.range(of: "foo") != nil }
                    
                    // then
                    expect(verifier("fast food")) == true
                }
                
                it("doesn't match if the test fails") {
                    // when
                    let verifier = any { (s: String) in s.range(of: "foo") != nil }
                    
                    // then
                    expect(verifier("hoopy frood")) == false
                }
            }
        }
    }
    
}
