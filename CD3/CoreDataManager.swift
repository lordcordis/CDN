//
//  CoreDataManager.swift
//  CD3
//
//  Created by wheatley on 28.08.23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "Storage")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data, \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving into Core Data, \(error.localizedDescription)")
        }
    }
}
