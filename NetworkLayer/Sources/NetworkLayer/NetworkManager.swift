//
//  ApiManager.swift
//  Airlines
//
//  Created by Sai Voruganti on 5/5/25.
//
 
import Foundation

public enum ApiError: Error {
    case invalidUrl, invalidResponse, jsonParsingFailed(String)
}

public enum HttpMethod: String {
    case get = "GET"
}

public protocol Request {
    var baseUrl: String { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var header: [String: String]? { get }
}

public extension Request {
    func createRequest() -> URLRequest? {
        guard let url = URL(string: baseUrl + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = header
        return request
    }
}

public protocol Servicable {
    func execute<T: Decodable>(request: Request, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

public class NetworkManager: Servicable {
    public init() {} // ← Add this to make it publicly accessible
    public func execute<T: Decodable>(request: Request, modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = request.createRequest() else {
            completion(.failure(ApiError.invalidUrl))
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let _data = data else {
                completion(.failure(ApiError.invalidResponse))
                return
            }
            do {
                let decode = try JSONDecoder().decode(modelType, from: _data)
                print(decode)
                
                completion(.success(decode))
            } catch {                
                completion(.failure(ApiError.jsonParsingFailed(error.localizedDescription)))
            }
        }.resume()
    }
}
