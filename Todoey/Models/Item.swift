//
//  Item.swift
//  Todoey
//
//  Created by gokulparmar on 23/08/22.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self , property: "items")
}
