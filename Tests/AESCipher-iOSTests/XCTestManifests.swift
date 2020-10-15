import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AESCipher_iOSTests.allTests),
    ]
}
#endif
