//
//  LocaleDataSource.swift
//  Core
//
//  Created by Dzulfaqar on 18/06/22.
//

import Combine
import Foundation

public protocol LocaleDataSource {
    associatedtype Request
    associatedtype Response

    func list(request: Request?) -> AnyPublisher<[Response], Error>
    func get(id: Int?) -> AnyPublisher<Response, Error>
    func add(data: [Response]) -> AnyPublisher<Bool, Error>
    func update(data: Response) -> AnyPublisher<Bool, Error>
    func delete(id: Int) -> AnyPublisher<Bool, Error>
}
