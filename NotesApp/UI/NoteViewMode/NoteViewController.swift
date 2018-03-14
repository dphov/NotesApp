//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Dmitry Petukhov on 02/03/2018.
//  Copyright © 2018 Dmitry Petukhov. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

  var realmManager = RealmManager()

  @IBAction func editButtonClicked(_ sender: Any) {
    print("Edit button clicked!")
  }

  
  @IBOutlet weak var noteDescriptionTextView: UITextView!
  
  @IBOutlet weak var noteCreationTimeLabel: UILabel!

  var noteObject: Note = Note()

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func viewWillAppear(_ animated: Bool) {
    
    let specificNote = realmManager.getSpecificObject(type: Note.self, primaryKey: noteObject.id) as! Note

    print("specificNote \(specificNote)")
    self.title = specificNote.title
    noteDescriptionTextView.text = specificNote.noteDescription

    let dateFormatter = DateFormatter()
    let date = specificNote.creationTime
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy HH:mm")
    
    noteCreationTimeLabel.text = dateFormatter.string(from: date)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if (segue.identifier == "intoNoteEditView") {
      let destinationVC = segue.destination as? NoteEditViewController
      destinationVC?.noteObject = noteObject
      destinationVC?.mode = ActionType.noteModification
    }

  }


}

