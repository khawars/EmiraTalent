//
//  SearchService.swift
//  EmiraTalentAssignment
//
//  Created by Khawar Shahzad on 22/10/2022.
//

import Foundation

enum Endpoints: String {
    case contentUrl = "https://api.npoint.io/8911c902fb4b24750e8e"
}

protocol Request {
    var urlRequest: URLRequest { get }
}

struct NetworkRequest: Request {
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }

    var url: URL
}

/// An abstract service type that can have multiple implementation for example - a NetworkService that gets a resource from the Network or a DiskService that gets a resource from Disk
protocol Service {
    func get(request: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

/// A concrete implementation of Service class responsible for getting a Network resource
final class NetworkService: Service {
    enum ServiceError: Error {
        case noData
    }

    func get(request: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request.urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
