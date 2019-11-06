import Foundation

public enum YouTrackError: Error {
    case decodingFailed(error: Error, data: Data)
    case emptyResponse
    case noHTTPResponse
    case statusCodeErrored(code: Int, message: String?)
    case unexpectingCustomFieldsFormat
    case urlFailed
    case wrappedError(originalError: Error)
}

extension YouTrackError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingFailed(let error, let data):
            let dataAsString = String(data: data, encoding: .utf8)
                ?? "--data couldn't be represented as UTF-8 string--"
            return "Decoding failed (error: \(error), data: \(dataAsString)"
        case .emptyResponse:
            return "YouTrack didn't respond with data"
        case .noHTTPResponse:
            return "Couldn't get HTTP response details"
        case .statusCodeErrored(let httpStatusCode, let bodyMessage):
            return "Response has status code \(httpStatusCode), with message: \(bodyMessage ?? "-- no message --")"
        case .unexpectingCustomFieldsFormat:
            return "Please review custom fields decodability"
        case .urlFailed:
            return "Couldn't build a URL for the request"
        case .wrappedError(let error):
            return "Failed with: \(error)"
        }
    }
}
