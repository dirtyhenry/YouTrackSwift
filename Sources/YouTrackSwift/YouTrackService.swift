import Foundation

public protocol YouTrackServiceProtocol {
    func listAgiles(
        completion: @escaping(Result<[Agile], YouTrackError>) -> Void
    )

    func listAgileSprints(
        agileID: String,
        nbOfResults: Int,
        completion: @escaping(Result<[Sprint], YouTrackError>) -> Void
    )
    
    func listSprintIssues(
        agileID: String,
        sprintID: String,
        completion: @escaping(Result<DetailedSprint, YouTrackError>) -> Void
    )
    
    func fetchIssue(
        issueID: String,
        completion: @escaping(Result<Issue, YouTrackError>) -> Void
    )
}

public final class YouTrackService: YouTrackServiceProtocol {
    let baseURL: String
    let authorizationHeader: String
    
    public init(baseURL: String, authorizationHeader: String) {
        self.baseURL = baseURL
        self.authorizationHeader = authorizationHeader
    }
    
    public func listAgiles(
        completion: @escaping (Result<[Agile], YouTrackError>) -> Void
    ) {
        fetch(
            urlAsString: "\(baseURL)/agiles?fields=id,name",
            completion: completion
        )
    }
    
    public func listAgileSprints(
        agileID: String,
        nbOfResults: Int = 100,
        completion: @escaping(Result<[Sprint], YouTrackError>) -> Void
    ) {
        fetch(
            urlAsString: "\(baseURL)/agiles/\(agileID)/sprints?$top=\(nbOfResults)&fields=id,name",
            completion: completion
        )
    }
    
    public func listSprintIssues(
        agileID: String,
        sprintID: String,
        completion: @escaping (Result<DetailedSprint, YouTrackError>) -> Void
    ) {
        fetch(urlAsString: "\(baseURL)/agiles/\(agileID)/sprints/\(sprintID)/?fields=id,name,issues(id,idReadable,summary)",
              completion: completion)
    }
    
    public func fetchIssue(
        issueID: String,
        completion: @escaping (Result<Issue, YouTrackError>) -> Void
    ) {
        fetch(urlAsString: "\(baseURL)/issues/\(issueID)?fields=id,summary,customFields($type,id,name,projectCustomField($type,id,field($type,id,name)),value($type,id,isResolved,name))",
              completion: completion)
    }
    
    private func fetch<Resource: Decodable>(
        urlAsString: String,
        completion: @escaping(Result<Resource, YouTrackError>) -> Void
    ) {
        guard let fetchURL = URL(string: urlAsString) else {
            return completion(.failure(.urlFailed))
        }
        
        var request = URLRequest(url: fetchURL)
        request.httpMethod = "GET"
        request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(.wrappedError(originalError: error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.noHTTPResponse))
            }
            
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                let message = data
                    .map { String(data: $0, encoding: .utf8) ?? "--data couldn't be converted to String--" }
                return completion(.failure(.statusCodeErrored(code: httpResponse.statusCode, message: message)))
            }
            
            guard let data = data else {
                return completion(.failure(.emptyResponse))
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Resource.self, from: data)
                return completion(.success(response))
            } catch {
                return completion(.failure(.decodingFailed(error: error, data: data)))
            }
        }.resume()
    }
}
