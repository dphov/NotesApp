//
//  Note.swift
//  NotesApp
//
//  Created by Dmitry Petukhov on 01/03/2018.
//  Copyright © 2018 Dmitry Petukhov. All rights reserved.
//

import UIKit
import RealmSwift

class Note: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var noteDescription: String = ""
  @objc dynamic var creationTime: Date = Date()
  @objc dynamic var modificationTime: Date = Date()

  override static func primaryKey() -> String? {
    return "id"
  }

  convenience init(id: Int, title: String, noteDescription: String, creationTime: Date, modificationTime: Date) {
    self.init()
    self.id = id
    self.title = title
    self.noteDescription = noteDescription
    self.creationTime = creationTime
    self.modificationTime = modificationTime
  }
}

enum ActionType {
  case noteCreation
  case noteModification
}
