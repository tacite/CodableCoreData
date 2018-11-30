//
//  BaseManagedObject.swift
//  Parsing
//
//  Created by David Tacite on 21/11/2018.
//  Copyright © 2018 David Tacite. All rights reserved.
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

public class BaseManagedObject : NSManagedObject, Codable {

    required convenience public init(from decoder: Decoder) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: type(of: self)), in: CoreDataManager.shared.managedObjectContext) else {fatalError("Failed to Decode") }

        self.init(entity: entity, insertInto: nil)
        try self.decode(to: decoder)
    }
    
    func decode(to decoder: Decoder) throws {
    }
    
    public func encode(to encoder: Encoder) throws {
    }
}
