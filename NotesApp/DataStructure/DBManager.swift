//
//  DBManager.swift
//  NotesApp
//
//  Created by Dmitry Petukhov on 01/03/2018.
//  Copyright © 2018 Dmitry Petukhov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
  // swiftlint:disable:next force_try
  let realm = try! Realm()

  // delete table
  func deleteDatabase() {
    try? realm.write({
      realm.deleteAll()
    })
  }

  // delete particular object
  func deleteObject(objs : Object) {
    try? realm.write ({
      realm.delete(objs)
    })
  }

  //Save array of objects to database
  func saveObjects(objs: Object) {
    try? realm.write ({
      // If update = false, adds the object
      realm.add(objs, update: false)
    })
  }

  // editing the object
  func editObjects(objs: Object) {
    try? realm.write ({
      // If update = true, objects that are already in the Realm will be
      // updated instead of added a new.
      realm.add(objs, update: true)
    })
  }

  //Returs an array as Results<object>?
  func getObjects(type: Object.Type) -> Results<Object>? {
    return realm.objects(type)
  }
  func getSpecificObject(type: Object.Type, primaryKey: Int) -> Object? {
    return realm.object(ofType: type, forPrimaryKey: primaryKey)
  }

  func incrementID() -> Int {
    return (realm.objects(Note.self).max(ofProperty: "id") as Int? ?? 0) + 1
  }

}
