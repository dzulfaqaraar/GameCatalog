//
//  CommonLocaleDataSource.swift
//  Common
//
//  Created by Dzulfaqar on 19/06/22.
//

import CoreData
import Foundation

public enum CommonLocaleDataSource {
    public static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameCatalog")

        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil

        return container
    }()

    public static func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()

        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return taskContext
    }
}
