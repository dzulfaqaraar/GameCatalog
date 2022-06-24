//
//  FavoriteUseCase.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Combine
import Common
import Foundation

protocol FavoriteUseCase {
    func getAllFavorite() -> AnyPublisher<[FavoriteModel], Error>
}
