//
//  EditorView.swift
//  QuickNotes
//
//  Created by Suruchi Sinha on 10/04/17.
//  Copyright © 2017 Suruchi Sinha. All rights reserved.
//

import UIKit

protocol EditorViewDelegate: NSObjectProtocol {
    func saveData(title: String?, description: String?)
    func enableKeyboardDismissAction(status: Bool)
}

class EditorView: UIView, UITextViewDelegate {
    
    weak var delegate   : EditorViewDelegate?
    var editorTextView  : UITextView!
    var editorText      : String?
    var keyboardShown = false
    
    init(frame: CGRect, notesText: String?) {
        super.init(frame: frame)
        editorText = notesText
        configureView()
    }
    
    func configureView() {
        editorTextView = UITextView(frame: self.bounds)
        editorTextView.delegate = self
        editorTextView.showsVerticalScrollIndicator = false
        editorTextView.textContainerInset = UIEdgeInsetsMake(1.0, 2.0, 1.0, 0.0)
        editorTextView.font = UIFont(name: "Verdana", size: 16.0)
        editorTextView.backgroundColor = UIColor.clear
        if editorText != nil {
            editorTextView.text = editorText!
        }
        self.addSubview(editorTextView)
        NotificationCenter.default.addObserver(self, selector: #selector(EditorView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditorView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func dismissKeyboard() {
        editorTextView.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            editorTextView.frame.size.height -= keyboardSize.height
            if self.delegate != nil {
                self.delegate?.enableKeyboardDismissAction(status: true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            editorTextView.frame.size.height += keyboardSize.height
            if self.delegate != nil {
                self.delegate?.enableKeyboardDismissAction(status: false)
            }
        }
    }
    
    func processNotesText() {
        if (self.delegate != nil) {
            editorText = editorTextView.text
            let titleText = getTitleText()
            editorTextView.resignFirstResponder()
            NotificationCenter.default.removeObserver(self)
            self.delegate?.saveData(title: titleText, description: editorText);
        }
    }
    
    func clearTextView() {
        editorTextView.text = ""
    }
    
    func getTitleText() -> String? {
        var title: String?
        var text = editorTextView.text
        text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let charCount = text!.characters.count
        if (text != nil && charCount > 0) {
            var newlinePos = 0
            var blankspacePos = 0
            let newlineIndex = text?.characters.index(of: "\n")
            let blankspaceIndex = text?.characters.index(of: " ")
            
            if newlineIndex != nil {
                newlinePos = (text?.characters.distance(from: (text?.startIndex)!, to: newlineIndex!))!
            }
            if blankspaceIndex != nil {
                blankspacePos = (text?.characters.distance(from: (text?.startIndex)!, to: blankspaceIndex!))!
            }
            if newlinePos > 0 && newlinePos < blankspacePos {
                title = text?.substring(to: newlineIndex!)
            }else if blankspacePos > 0{
                title = text?.substring(to: blankspaceIndex!)
            }else {
                title = text
            }
        }else {
            title = nil
        }
        return title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
