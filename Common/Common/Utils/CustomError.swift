//
//  CustomError.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case noConnection
    case invalidResponse
    case requestError(message: String? = nil)

    public var errorDescription: String? {
        switch self {
        case .noConnection:
            return "no_internet_connection".localized()
        case let .requestError(message):
            return message
        default:
            return "something_went_wrong".localized()
        }
    }
}

public enum DatabaseError: LocalizedError {
    case requestFailed

    public var errorDescription: String? {
        switch self {
        case .requestFailed: return "request_failed".localized()
        }
    }
}
