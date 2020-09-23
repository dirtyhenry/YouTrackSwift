# YouTrackSwift

[![Swift 5.3](https://img.shields.io/badge/swift-5.3-ED523F.svg?style=flat)](https://swift.org/download/)

A Swift package for querying [YouTrack](https://www.jetbrains.com/youtrack/).

## Requirements

* Swift 5.3
* Homebrew

## Usage

```
make install
```

Then create a file at `Tests/YouTrackSwiftTests/TestConfig.swift` that should look like this:

```
import Foundation

struct TestConfig {
    // API configuration
    static let baseURL = "https://youtrack.FOO.TLD/api"
    static let authorizationHeader = "Bearer perm:AN-API-TOKEN"

    // Agile configuration
    static let minimumNumberOfAgiles = 20
    static let defaultAgileName = "NAME OF AN AGILE"

    // Sprint configuration
    static let minimumNumberOfSprintsForDefaultAgile = 49
    static let defaultAgileID = "ID OF AN AGILE"
    static let defaultSprintID = "ID OF A SPRINT"
    static let numberOfIssuesOfDefaultSprint = 103
    static let defaultIssueIDOfDefaultSprint = "AN ISSUE ID"
    static let defaultIssueIDOfDefaultSprintAssignee = "AN ISSUE ASSIGNEE'S NAME"

    // Issue configuration
    static let defaultIssueID = "ID OF AN ISSUE"
    static let defaultIssueReadableID = "READABLE ID OF AN ISSUE"
    static let defaultIssueSummary = "SUMMARY OF AN ISSUE"
    static let defaultIssueAssignee = "AN ISSUE ASSIGNEE'S NAME"
    static let defaultIssueStoryPoints = 0
    
    // Saved Query configuration
    static let minimumNumberOfSavedQueries = 30
    static let defaultSavedQueryID = "AN ID OF A SAVED QUERY"
    static let defaultSavedQueryName = "A NAME OF A SAVED QUERY"
}
```
