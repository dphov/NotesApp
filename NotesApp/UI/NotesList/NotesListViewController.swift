//
//  ViewController.swift
//  NotesApp
//
//  Created by Dmitry Petukhov on 01/03/2018.
//  Copyright © 2018 Dmitry Petukhov. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class NotesListViewController: UITableViewController {
  // swiftlint:disable:next force_try
  lazy var realm = try! Realm()
  var defaultOptions = SwipeTableOptions()
  
  var notesList: Results<Note> {
    get {
      return realm.objects(Note.self)
    }
  }
  var sortedNotesList: Results<Note>!
  
  @IBAction func addButtonClicked(_ sender: Any) {
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sortedNotesList = notesList.sorted(byKeyPath: "creationTime", ascending: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sortedNotesList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as? NotesCell
    cell?.delegate = self
    let rowItem = sortedNotesList[indexPath.row]
    
    cell?.titleLabel!.text = rowItem.title
    cell?.dateLabel!.text = String(describing: rowItem.creationTime)
    
    return cell!
  }
  
  // MARK: - Prepare for segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "intoNoteCreationView"{
      
      let destinationVC = segue.destination as? NoteEditViewController
      destinationVC?.mode = ActionType.noteCreation
      
    } else if segue.identifier == "intoNoteView" {
      
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let selectedRow = indexPath.row
        var selectedNote: Note! = self.sortedNotesList[selectedRow]
        let destinationVC = segue.destination as? NoteViewController
        destinationVC?.noteObject = selectedNote
      }
      
    }
    
  }
  
  
}

extension NotesListViewController: SwipeTableViewCellDelegate  {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .left else { return nil }
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
      
      
      // swiftlint:disable:next force_try
      try! self.realm.write ({
        self.realm.delete(self.sortedNotesList[indexPath.row])
      })
      action.fulfill(with: .delete)
    }
    return [deleteAction]
  }
  
  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
    var options = SwipeTableOptions()
    options.expansionStyle = .destructive
    options.transitionStyle = defaultOptions.transitionStyle
    return options
  }
}

