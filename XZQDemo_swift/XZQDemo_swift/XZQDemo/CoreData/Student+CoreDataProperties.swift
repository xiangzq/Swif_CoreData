//
//  Student+CoreDataProperties.swift
//  XZQDemo_swift
//
//  Created by 项正强 on 2018/1/12.
//  Copyright © 2018年 项正强. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var sex: Bool

}
