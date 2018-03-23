//
//  ViewController.swift
//  NotesApp
//
//  Created by Dmitry Petukhov on 01/03/2018.
//  Copyright © 2018 Dmitry Petukhov. All rights reserved.
//

import UIKit
import RealmSwift


class NotesListViewController: UITableViewController {
    var notificationToken: NotificationToken? = nil
    lazy var realm = try! Realm()

    var results: Results<Note> {
        get {
            return realm.objects(Note.self).sorted(byKeyPath: "creationTime", ascending: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }

            switch changes {
            case .initial: tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                let fromRow = {(row: Int) in
                    return IndexPath(row: row, section: 0)}
                tableView.beginUpdates()
                tableView.deleteRows(at: deletions.map(fromRow), with: .automatic)
                tableView.insertRows(at: insertions.map(fromRow), with: .automatic)
                tableView.reloadRows(at: updates.map(fromRow), with: .none)
                tableView.endUpdates()
            case .error(let error): fatalError("\(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as? NotesCell else {return UITableViewCell()}

        let rowItem = results[indexPath.row]

        cell.titleLabel!.text = rowItem.title

        let dateFormatter = DateFormatter()
        let date = rowItem.creationTime
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy HH:mm")

        cell.dateLabel!.text = dateFormatter.string(from: date)

        return cell
    }

    // MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier! {
        case "intoNoteCreationView":
            let destinationVC = segue.destination as? NoteEditViewController
            destinationVC?.mode = ActionType.noteCreation
        case "intoNoteView":
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let selectedNote: Note! = self.results[selectedRow]
                let destinationVC = segue.destination as? NoteViewController
                destinationVC?.noteObject = selectedNote
            }
        default:
            fatalError("Segue does not exist")

        }
    }
}

// MARK: - Deletion
extension NotesListViewController  {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)

            let objectToDelete = self.results[indexPath.row]
            try! realm.write {
                realm.delete(objectToDelete)
            }
        }
    }
}
