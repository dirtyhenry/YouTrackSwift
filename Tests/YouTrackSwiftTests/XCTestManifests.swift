import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(YouTrackSwiftTests.allTests)
        ]
    }
#endif
