//
//  SproutImageDataMO-v102.swift
//  Sprout
//
//  Created by Ryan Thally on 6/16/21.
//

import UIKit
import CoreData

final class SproutImageDataMO: NSManagedObject {
    override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID().uuidString, forKey: #keyPath(SproutImageDataMO.identifier))
        setPrimitiveValue(Date(), forKey: #keyPath(SproutImageDataMO.creationDate))
        setPrimitiveValue(Date(), forKey: #keyPath(SproutImageDataMO.lastModifiedDate))
    }

    override func willSave() {
        super.willSave()

        setPrimitiveValue(Date(), forKey: #keyPath(SproutImageDataMO.lastModifiedDate))
    }
}
