//
//  CoreDataStack.swift
//  GoTouchGrass
//
//  Created by Ditthapong Lakagul on 9/5/2567 BE.
//

import CoreData
import Foundation

class CoreDataStack {
    static let shared = CoreDataStack() // Singleton instance

    // Persistent container for managing Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DailyDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading Core Data stack: \(error)") // Fatal error on initialization failure
            }
        }
        return container
    }()

    // Main context for Core Data operations
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save context changes
    func saveContext() {
        let context = persistentContainer.viewContext // Ensure context is fetched correctly
        if context.hasChanges {
            do {
                try context.save() // Attempt to save changes
            } catch {
                print("Error saving Core Data context:", error) // Handle save errors
            }
        }
    }
}

