//
//  NSManagedObject+Provider.swift
//  Parsing
//
//  Created by David Tacite on 30/11/2018.
//  Copyright © 2018 David Tacite. All rights reserved.
//

import Foundation
import CoreData

// PROVIDER
public extension NSManagedObject {
    
    public static func entityName() -> String {
        return String(describing: self)
    }
}


// MARK: CREATE
public extension NSManagedObject{
    public static func newObjectInstance() -> NSManagedObject? {
        return CoreDataManager.shared.newObjectInstanceFor(entity: self.entityName())
    }
    
    
}

// MARK: REQUEST
public extension NSManagedObject{
    // MARK: - used to retrieve all objects
    public static func allObjects() -> [AnyObject]? {
        return CoreDataManager.shared.allObjectsFor(entity: self.entityName())
    }
    
    // MARK: - used to retrieve an object with a predicate
    public static func objectWith(predicate:NSPredicate?) -> AnyObject? {
        return self.objectsWith(predicate: predicate)?.first
    }
    
    public static func objectsWith(predicate:NSPredicate?) -> [AnyObject]? {
        return CoreDataManager.shared.objectsWith(entity: self.entityName(), andPredicate: predicate)
    }
}

//MARK: REMOVE
public extension NSManagedObject{
    // MARK: - used to remove objects, returns count of removed elements
    public static func removeAllObjects() -> Int {
        return CoreDataManager.shared.removeAllObjectsWith(entity: self.entityName())
    }
    
    public static func removeObjectsWith(predicate:NSPredicate?) -> Int {
        return CoreDataManager.shared.removeObjectsWith(entity: self.entityName(), andPredicate: predicate)
    }
}
