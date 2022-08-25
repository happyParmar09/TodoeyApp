//
//  Category.swift
//  Todoey
//
//  Created by gokulparmar on 23/08/22.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}

