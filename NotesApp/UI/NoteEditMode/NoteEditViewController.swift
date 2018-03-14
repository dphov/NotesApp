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
  var noteObject: Note?
  var mode: ActionType!

  // This constraint ties an element at zero points from the bottom layout guide
  @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?

  @IBOutlet weak var titleTextField: UITextField!

  @IBOutlet weak var noteDescriptionTextView: UITextView!
  
  @IBAction func saveButtonClicked(_ sender: Any) {

    if titleTextField.text == "" || noteDescriptionTextView.text == "" {
      let alertViewController = UIAlertController(title: "Attention!", message: "Your note have an empty fields, return to editor?", preferredStyle: .alert)

      let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] (action) -> Void in
        self?.navigationController?.popViewController(animated: true)
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
    print(mode)
    switch mode {
    case .noteCreation:
      break
    case .noteModification:
      titleTextField.text = noteObject?.title
      noteDescriptionTextView.text = noteObject?.noteDescription
    default:
      break
    }
    // Do any additional setup after loading the view.


    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.keyboardWasShown(notification:)),
                                           name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                           object: nil)

  }

  deinit {
    NotificationCenter.default.removeObserver(self);
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

// MARK: - Save note
extension NoteEditViewController {

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
        let noteUpdate = Note(id: (noteObject?.id)!, title: title, noteDescription: noteDescription, creationTime: (noteObject?.creationTime)!, modificationTime: Date())
        realmManager.editObjects(objs: noteUpdate)
    }
  }
}



// MARK: - UITextView keyboardWasShown
extension NoteEditViewController:  UITextViewDelegate {

  @objc func keyboardWasShown(notification: Notification) {
    print("NoteEditViewController keyboardWasShown\n")
    let info = notification.userInfo
    let kbSize: CGSize? = (info?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue?.size
    let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (kbSize?.height)!, right: 0.0)
    noteDescriptionTextView.contentInset = contentInsets
    noteDescriptionTextView.scrollIndicatorInsets = contentInsets

  }

}
