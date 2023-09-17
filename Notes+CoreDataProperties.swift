//
//  Notes+CoreDataProperties.swift
//  Notes2
//
//  Created by PVH_002 on 14/9/23.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?

}

extension Notes : Identifiable {

}
