//
//  NetworkManager.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Alamofire
import Combine
import Foundation
import SystemConfiguration

public enum NetworkEndpoint {
    static let hostname = "api.rawg.io"
    static let baseUrl = "https://\(hostname)/api/"
    static let apiKey = ""
    public static let genres = baseUrl + "genres"
    public static let games = baseUrl + "games"
    public static let detail = baseUrl + "games/"
}

public struct NetworkManager {
    public init() {}

    public func performRequest<T: Codable>(
        url: String, params: [String: Any?]? = nil
    ) -> AnyPublisher<T?, Error> {
        return Future<T?, Error> { completion in
            if !isConnected() {
                completion(.failure(NetworkError.noConnection))
            }

            var parameters: [String: Any] = params?.mapValues { $0 ?? "" } ?? [:]
            parameters["key"] = NetworkEndpoint.apiKey

            print("URL: \(url) with parameters: \(parameters)")
            AF.request(url, parameters: parameters)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(value):
                        completion(.success(value))
                    case .failure:
                        completion(.failure(NetworkError.invalidResponse))
                    }
                }
        }.eraseToAnyPublisher()
    }

    private func isConnected() -> Bool {
        let reachability = SCNetworkReachabilityCreateWithName(nil, NetworkEndpoint.hostname)
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)

        return isNetworkReachable(with: flags)
    }

    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}
