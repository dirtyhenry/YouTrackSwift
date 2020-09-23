import XCTest
import YouTrackSwift

final class YouTrackServiceTests: XCTestCase {
    private var service: YouTrackService!

    override func setUp() {
        service = YouTrackService(
            baseURL: TestConfig.baseURL,
            authorizationHeader: TestConfig.authorizationHeader
        )
    }

    func testAgilesFetching() {
        let completion = XCTestExpectation(description: "Listing agiles completes")
        var result: Result<[Agile], YouTrackError>?
        service.listAgiles { fetchedResult in
            result = fetchedResult
            completion.fulfill()
        }

        wait(for: [completion], timeout: 5.0)
        XCTAssertNotNil(result)
        if case let .success(agilesCollection) = result {
            XCTAssert(agilesCollection.count >= TestConfig.minimumNumberOfAgiles)
            XCTAssert(agilesCollection.filter { $0.id == TestConfig.defaultAgileID }.count == 1)
            XCTAssert(agilesCollection.filter { $0.name == TestConfig.defaultAgileName }.count == 1)
        } else {
            XCTFail("fetching agiles failed")
        }
    }

    func testAgileSprintsFetching() {
        let completion = XCTestExpectation(description: "Listing sprints of an agile completes")
        var result: Result<[Sprint], YouTrackError>?
        service.listAgileSprints(agileID: TestConfig.defaultAgileID) { fetchedResult in
            result = fetchedResult
            completion.fulfill()
        }

        wait(for: [completion], timeout: 5.0)
        XCTAssertNotNil(result)
        if case let .success(sprintCollection) = result {
            XCTAssert(sprintCollection.count >= TestConfig.minimumNumberOfSprintsForDefaultAgile)
            XCTAssert(sprintCollection.filter { $0.id == TestConfig.defaultSprintID }.count == 1)
        } else {
            XCTFail("fetching sprints of an agile failed")
        }
    }

    func testSprintIssuesFetching() {
        let completion = XCTestExpectation(description: "Listing issues of a sprint completes")
        var result: Result<DetailedSprint, YouTrackError>?
        service.listSprintIssues(
            agileID: TestConfig.defaultAgileID,
            sprintID: TestConfig.defaultSprintID
        ) { fetchedResult in
            result = fetchedResult
            completion.fulfill()
        }

        wait(for: [completion], timeout: 5.0)
        switch result {
        case let .success(detailedSprint):
            XCTAssertEqual(detailedSprint.id, TestConfig.defaultSprintID)
            XCTAssertEqual(
                detailedSprint.issues.count,
                TestConfig.numberOfIssuesOfDefaultSprint
            )
            XCTAssertEqual(
                detailedSprint
                    .issues
                    .filter { $0.idReadable == TestConfig.defaultIssueIDOfDefaultSprint }
                    .count, 1
            )
        case let .failure(error):
            XCTFail(error.localizedDescription)
        case nil:
            XCTFail("Result must not be nil after completion")
        }
    }

    func testIssueFetching() {
        let completion = XCTestExpectation(description: "Fetching issue completes")
        var result: Result<Issue, YouTrackError>?
        service.fetchIssue(issueID: TestConfig.defaultIssueReadableID) { fetchedResult in
            result = fetchedResult
            completion.fulfill()
        }

        wait(for: [completion], timeout: 5.0)

        switch result {
        case let .success(issue):
            XCTAssertEqual(issue.id, TestConfig.defaultIssueID)
            XCTAssertEqual(issue.idReadable, TestConfig.defaultIssueReadableID)
            XCTAssertEqual(issue.summary, TestConfig.defaultIssueSummary)
            XCTAssertEqual(issue.assignee, TestConfig.defaultIssueAssignee)
            XCTAssertEqual(issue.storyPoints, TestConfig.defaultIssueStoryPoints)
        case let .failure(error):
            XCTFail(error.localizedDescription)
        case nil:
            XCTFail("Result must not be nil after completion")
        }
    }

    func testSavedQueriesFetching() {
        let completion = XCTestExpectation(description: "Listing saved queries completes")
        var result: Result<[SavedQuery], YouTrackError>?
        service.listSavedQueries { fetchedResult in
            result = fetchedResult
            completion.fulfill()
        }

        wait(for: [completion], timeout: 5.0)
        XCTAssertNotNil(result)
        if case let .success(savedQueriesCollection) = result {
            XCTAssert(savedQueriesCollection.count >= TestConfig.minimumNumberOfSavedQueries)
            XCTAssert(savedQueriesCollection.filter { $0.id == TestConfig.defaultSavedQueryID }.count == 1)
            XCTAssert(savedQueriesCollection.filter { $0.name == TestConfig.defaultSavedQueryName }.count == 1)
        } else {
            XCTFail("fetching agiles failed")
        }
    }
}
