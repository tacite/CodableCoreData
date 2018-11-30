//
//  Amiibo+CoreDataProperties.swift
//  
//
//  Created by David Tacite on 21/11/2018.
//
//

import Foundation
import CoreData


extension Amiibo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Amiibo> {
        return NSFetchRequest<Amiibo>(entityName: "Amiibo")
    }
    
    @NSManaged public var amiiboSeries: String?
    @NSManaged public var character: String?
    @NSManaged public var gameSeries: String?
    @NSManaged public var type: String?
    @NSManaged public var name: String?

    enum CodingKeys: String, CodingKey {
        case amiiboSeries
        case character
        case gameSeries
        case type
        case name
    }
}
