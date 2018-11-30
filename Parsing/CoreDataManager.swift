//
//  CoreDataManager.swift
//  Parsing
//
//  Created by David Tacite on 30/11/2018.
//  Copyright © 2018 David Tacite. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataManager: NSObject {
    
    // MARK: - Properties
    
    public var managedObjectContext : NSManagedObjectContext!
    public var managedObjectModel : NSManagedObjectModel!
    public var persistentStoreCoordinator : NSPersistentStoreCoordinator!
    
    // MARK: - Instance
    public static var shared : CoreDataManager = {
        return CoreDataManager()
    }()
    
    // initialize manager with model name
    open func setCoreDataModel(withName momdName:String){
        
        guard let applicationDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else{
            print("Failed getting documents directory!!!")
            return
        }
        
        // Init managed object model
        let modeURL = Bundle.main.bundleURL.appendingPathComponent(momdName + ".momd")
        self.managedObjectModel = NSManagedObjectModel(contentsOf: modeURL)
        
        
        // init persistent store coordinator
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent(momdName + ".sqlite")
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let  error as NSError {
            print("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        
        // init managed object context
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        self.managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
}

//MARK: CREATE
public extension CoreDataManager{
    public func newObjectInstanceFor(entity:String) -> NSManagedObject? {
        let objectContext:NSManagedObjectContext = self.managedObjectContext
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entity, into: objectContext)
        return managedObject
    }
}

//MARK: DATA REQUEST
public extension CoreDataManager{
    
    // MARK: - used to retrieve a list of objects with a predicate
    public func objectsWith(entity:String, andPredicate predicate:NSPredicate?) -> [AnyObject]? {
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>();
        let objectContext:NSManagedObjectContext = self.managedObjectContext
        if let entityDesc:NSEntityDescription = NSEntityDescription.entity(forEntityName: entity, in: objectContext) {
            fetchRequest.entity = entityDesc
            fetchRequest.predicate = predicate
            do {
                return try objectContext.fetch(fetchRequest)
            }
            catch let error {
                print("\(entity) error : \(error)")
            }
        }
        
        return nil
    }
    
    // returns all objects of provided entity type
    public func allObjectsFor(entity:String) -> [AnyObject]? {
        return self.objectsWith(entity:entity, andPredicate: nil)
    }
}

//MARK: REMOVE REQUEST
public extension CoreDataManager{
    // MARK: - used to remove an object
    public func remove(object:NSManagedObject) {
        self.managedObjectContext.delete(object)
    }
    
    public func remove(objects:[NSManagedObject]){
        for obj in objects{
            // remove each element
            self.remove(object: obj)
        }
    }
    // remove all object in coredata matching entity name
    public func removeAllObjectsWith(entity:String) -> Int {
        return self.removeObjectsWith(entity: entity, andPredicate:nil)
    }
    // remove elements matching entity and predicate
    public func removeObjectsWith(entity:String, andPredicate predicate:NSPredicate?) -> Int {
        guard let toRemoveObjects = self.objectsWith(entity: entity, andPredicate:predicate) as? [NSManagedObject] else{
            // no elements
            return 0
        }
        
        let removedObjectsCount = toRemoveObjects.count
        self.remove(objects:toRemoveObjects)
        
        return removedObjectsCount
    }
    
}

// MARK : Context
public extension CoreDataManager{
    // Save CoreData
    public func saveContext() -> Bool {
        
        if self.managedObjectContext.hasChanges{
            do {
                // We try to save
                try self.managedObjectContext.save()
            }
            catch let error {
                print("saveContext error : \(error)")
                return false
            }
            return true
        }
        return false
    }
    
    // Cancel the last action
    public func rollBackContext() {
        self.managedObjectContext.rollback()
    }
}
