//
//  HomeLocaleDataSource.swift
//  Catalog
//
//  Created by Dzulfaqar on 19/06/22.
//

import Combine
import Common
import CoreData
import UIKit

protocol HomeLocaleDataSourceProtocol: AnyObject {
    // MARK: - CoreData

    func getAllGenres() -> AnyPublisher<[GenreEntity], Error>
    func insertGenres(from genres: [GenreEntity]) -> AnyPublisher<Bool, Error>
    func getAllFavorite() -> AnyPublisher<[FavoriteEntity], Error>
}

final class HomeLocaleDataSource: NSObject {}

extension HomeLocaleDataSource: HomeLocaleDataSourceProtocol {
    // MARK: - CoreData

    func getAllGenres() -> AnyPublisher<[GenreEntity], Error> {
        return Future<[GenreEntity], Error> { completion in

            let taskContext = CommonLocaleDataSource.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Genre")
                let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                fetchRequest.sortDescriptors = [sortDescriptor]

                do {
                    let results = try taskContext.fetch(fetchRequest)
                    var list: [GenreEntity] = []

                    for result in results {
                        let favorite = GenreEntity(
                            id: result.value(forKeyPath: "id") as? Int32,
                            name: result.value(forKeyPath: "name") as? String,
                            image: result.value(forKeyPath: "image") as? String
                        )
                        list.append(favorite)
                    }

                    completion(.success(list))
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                    completion(.failure(DatabaseError.requestFailed))
                }
            }
        }.eraseToAnyPublisher()
    }

    func insertGenres(from genres: [GenreEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in

            let taskContext = CommonLocaleDataSource.newTaskContext()
            taskContext.performAndWait {
                if let entity = NSEntityDescription.entity(forEntityName: "Genre", in: taskContext) {
                    for genre in genres {
                        let object = NSManagedObject(entity: entity, insertInto: taskContext)
                        object.setValue(genre.id, forKeyPath: "id")
                        object.setValue(genre.name, forKeyPath: "name")
                        object.setValue(genre.image, forKeyPath: "image")
                    }

                    do {
                        try taskContext.save()
                        completion(.success(true))
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                        completion(.failure(DatabaseError.requestFailed))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    func getAllFavorite() -> AnyPublisher<[FavoriteEntity], Error> {
        return Future<[FavoriteEntity], Error> { completion in

            let taskContext = CommonLocaleDataSource.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]

                do {
                    let results = try taskContext.fetch(fetchRequest)
                    var list: [FavoriteEntity] = []

                    for result in results {
                        let favorite = FavoriteEntity(
                            id: result.value(forKeyPath: "id") as? Int32,
                            image: result.value(forKeyPath: "image") as? String,
                            name: result.value(forKeyPath: "name") as? String,
                            released: result.value(forKeyPath: "released") as? String,
                            rating: result.value(forKeyPath: "rating") as? Double,
                            date: result.value(forKey: "date") as? Date
                        )
                        list.append(favorite)
                    }

                    completion(.success(list))
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                    completion(.failure(DatabaseError.requestFailed))
                }
            }
        }.eraseToAnyPublisher()
    }
}
