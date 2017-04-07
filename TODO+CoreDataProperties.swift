//
//  TODO+CoreDataProperties.swift
//  sampleCoreData
//
//  Created by 有希 on 2017/03/30.
//  Copyright © 2017年 Yuki Mitsudome. All rights reserved.
//

import Foundation
import CoreData


extension TODO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TODO> {
        return NSFetchRequest<TODO>(entityName: "TODO");
    }

    @NSManaged public var title: String?
    @NSManaged public var saveDate: NSDate?

}
