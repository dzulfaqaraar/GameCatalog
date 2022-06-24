//
//  DetailLocaleDataSource.swift
//  Detail
//
//  Created by Dzulfaqar on 19/06/22.
//

import Combine
import Common
import Core
import CoreData
import UIKit

public struct DetailLocaleDataSource: LocaleDataSource {
    public typealias Request = Int
    public typealias Response = FavoriteEntity

    public func list(request _: Int?) -> AnyPublisher<[FavoriteEntity], Error> {
        fatalError()
    }

    public func get(id: Int?) -> AnyPublisher<FavoriteEntity, Error> {
        Future<FavoriteEntity, Error> { completion in
            let taskContext = CommonLocaleDataSource.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                fetchRequest.fetchLimit = 1
                if let id = id {
                    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                }

                do {
                    if let result = try taskContext.fetch(fetchRequest).first {
                        let favorite = FavoriteEntity(
                            id: result.value(forKeyPath: "id") as? Int32,
                            image: result.value(forKeyPath: "image") as? String,
                            name: result.value(forKeyPath: "name") as? String,
                            released: result.value(forKeyPath: "released") as? String,
                            rating: result.value(forKeyPath: "rating") as? Double,
                            date: result.value(forKey: "date") as? Date
                        )
                        completion(.success(favorite))
                    }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                    completion(.failure(DatabaseError.requestFailed))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func add(data: [FavoriteEntity]) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { completion in
            let taskContext = CommonLocaleDataSource.newTaskContext()
            taskContext.performAndWait {
                if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                    for item in data {
                        let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                        favorite.setValue(item.id, forKeyPath: "id")
                        favorite.setValue(item.image, forKeyPath: "image")
                        favorite.setValue(item.name, forKeyPath: "name")
                        favorite.setValue(item.released, forKeyPath: "released")
                        favorite.setValue(item.rating, forKeyPath: "rating")
                        favorite.setValue(item.date, forKeyPath: "date")
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

    public func update(data _: FavoriteEntity) -> AnyPublisher<Bool, Error> {
        fatalError()
    }

    public func delete(id: Int) -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { completion in
            let taskContext = CommonLocaleDataSource.newTaskContext()
            taskContext.performAndWait {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")

                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeCount

                if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                    if batchDeleteResult.result != nil {
                        completion(.success(true))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
