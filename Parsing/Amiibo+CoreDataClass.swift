//
//  Amiibo+CoreDataClass.swift
//  
//
//  Created by David Tacite on 21/11/2018.
//
//

import Foundation
import CoreData

struct AmiiboList: Codable {
    let amiibo: [Amiibo]
}

@objc(Amiibo)
public class Amiibo: BaseManagedObject {

     override func decode(to decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amiiboSeries = try container.decodeIfPresent(String.self, forKey: .amiiboSeries)
        self.character = try container.decodeIfPresent(String.self, forKey: .character)
        self.gameSeries = try container.decodeIfPresent(String.self, forKey: .gameSeries)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }
    
     override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.amiiboSeries, forKey: .amiiboSeries)
        try container.encode(self.character, forKey: .character)
        try container.encode(self.gameSeries, forKey: .gameSeries)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.type, forKey: .type)
    }
}
