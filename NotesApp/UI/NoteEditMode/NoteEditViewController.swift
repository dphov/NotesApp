//
//  NoteEditViewController.swift
//  NotesApp
//
//  Created by Dmitry Petukhov on 01/03/2018.
//  Copyright © 2018 Dmitry Petukhov. All rights reserved.
//

import UIKit


class NoteEditViewController: UIViewController {
  var realmManager: RealmManager = RealmManager()
  var noteObject: Note = Note()
  var mode: ActionType!

  var alertActionString: String?

  @IBOutlet var titleTextField: UITextField!

  @IBOutlet var noteDescriptionTextView: UITextView!
  var textViewPlaceholderLabel : UILabel!
  @IBAction func saveButtonClicked(_ sender: Any) {

    if titleTextField.text == "" || noteDescriptionTextView.text == "" {
      let alertViewController = UIAlertController(title: "Attention!", message: "Your note have an empty fields, return to editor?", preferredStyle: .alert)

      let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
        self.alertActionString = "OK"
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) -> Void in
        self.alertActionString = "Cancel"
        self.navigationController?.popViewController(animated: true)
      }

      alertViewController.addAction(okAction)
      alertViewController.addAction(cancelAction)

      present(alertViewController, animated: true, completion: nil)

    } else {

      saveNote(actionType: mode)

      switch mode {
      case .noteCreation:
        print(self.navigationController?.viewControllers as Any)
        self.navigationController?.popToRootViewController(animated: true)
      case .noteModification:
        print(self.navigationController?.viewControllers as Any)
        self.navigationController?.popViewController(animated: true)
      default:
        break
      }

    }

  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(noteObject)
    print(mode)
    switch mode {
    case .noteCreation:
      break
    case .noteModification:
      titleTextField.text = noteObject.title
      noteDescriptionTextView.text = noteObject.noteDescription
    default:
      break
    }
    // Do any additional setup after loading the view.

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  /*
   MARK: - Navigation

   In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   Get the new view controller using segue.destinationViewController.
   Pass the selected object to the new view controller.
   }
   */


  func saveNote(actionType: ActionType) {
    print(saveNote)
    let title = String(self.titleTextField.text!)
    let noteDescription = String(self.noteDescriptionTextView.text!)

    switch actionType {
    case .noteCreation:
      let id = realmManager.incrementID()
      let noteCreation = Note(id: id, title: title, noteDescription: noteDescription, creationTime: Date(), modificationTime: Date())
      realmManager.saveObjects(objs: noteCreation)
    case .noteModification:
      let noteUpdate = Note(id: noteObject.id, title: title, noteDescription: noteDescription, creationTime: noteObject.creationTime, modificationTime: Date())
      realmManager.editObjects(objs: noteUpdate)
    }

  }
}
