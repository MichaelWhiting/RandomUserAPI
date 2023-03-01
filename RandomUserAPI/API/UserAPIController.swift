//
//  UserAPI.swift
//  RandomUserAPI
//
//  Created by Michael Whiting on 2/27/23.
//

import Foundation

enum APIRequestError: Error, LocalizedError {
    case infoRequestError
}
protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeResponse(data: Data) throws -> Response
}

func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
    let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw APIRequestError.infoRequestError
    }
    
    let decodedReponse = try request.decodeResponse(data: data)
    return decodedReponse
}

struct UserAPIRequest: APIRequest {
    var url: String
    
    var urlRequest: URLRequest {
        let urlComponents = URLComponents(string: url)!
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodeResponse(data: Data) throws -> Results {
        let decodedReponse = try JSONDecoder().decode(Results.self, from: data)
        return decodedReponse
    }
}
