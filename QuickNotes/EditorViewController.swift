//
//  EditorViewController.swift
//  QuickNotes
//
//  Created by Suruchi Sinha on 10/04/17.
//  Copyright © 2017 Suruchi Sinha. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, HeaderViewDelegate, EditorViewDelegate, FooterViewDelegate {

    /// The header view
    var headerView      : MainHeaderView!
    /// The content view containing the text view.
    var contentView     : EditorView!
    /// The footer view.
    var footerView      : MainFooterView!
    /// The height of the screen.
    var screenHeight    : CGFloat = 0.0
    /// The width of the screen.
    var screenWidth     : CGFloat = 0.0
    /// The height of the header view.
    let headerViewHeight: CGFloat = 60.0
    /// The height of the footer view.
    let footerViewHeight: CGFloat = 40.0
    /// Data Model Object
    let notesDataModel = NotesDataModel()
    /// Notes text object for edit mode
    private var notesText: String?
    /// Index of note cell to be updated
    private var indexOfCell: Int?
    /// Status of the note as favorite
    private var favStatus: Bool = false
    /// Date object for edit mode of selected note
    private var timeStamp: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = view.bounds.size.width
        screenHeight = view.bounds.size.height
        setupView()

    }

    /// This method configures the headerview and content view.
    func setupView() {
        view.backgroundColor = UIColor(colorLiteralRed: 240.0/255.0, green: 237.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        setupHeaderView()
        setupContentView()
        setupFooterView()
    }
    
    /// This method configures the header view.
    func setupHeaderView() {
        let xPos: CGFloat = 0.0
        let yPos: CGFloat = 0.0
        headerView = MainHeaderView(frame: CGRect(x: xPos, y: yPos, width: screenWidth, height: headerViewHeight), callingClass: .editorView)
        headerView.delegate = self
        view.addSubview(headerView)
    }
    
    func setupContentView() {
        let yOffset: CGFloat = 5.0
        let xPos: CGFloat = 5.0
        let yPos: CGFloat = headerView.frame.maxY + yOffset
        let contentViewHeight = screenHeight - headerViewHeight - footerViewHeight - yOffset
        contentView = EditorView(frame: CGRect(x: xPos, y: yPos, width: screenWidth - 2 * yOffset, height: contentViewHeight), notesText: notesText)
        contentView.delegate = self
        if notesText != nil {
            contentView.editorText = notesText
        }
        view.addSubview(contentView)
    }
    
    func setupFooterView() {
        let yPos = contentView.frame.maxY
        footerView = MainFooterView(frame: CGRect(x: 0, y: yPos, width: screenWidth, height: footerViewHeight), callingClass: .editorView)
        footerView.footerDelegate = self
        footerView.isFavSelected = favStatus
        footerView.setFooterTimestampLabel(timeStamp: timeStamp)
        view.addSubview(footerView)
    }
    
    func dismissViewController() {
        contentView.processNotesText()
    }
    
    func dismissKeyboard() {
        contentView.dismissKeyboard()
    }
    
    func deleteNote() {
        let alert = UIAlertController(title: "Alert", message: "Do you want to delete the note?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            action in
                DispatchQueue.main.async { [unowned self] in
                    self.contentView.clearTextView()
                }
                if self.indexOfCell != nil {
                    self.notesDataModel.deleteData(row: self.indexOfCell!)
                }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func markNoteAsFavourite(selectionStatus: Bool) {
        favStatus = selectionStatus
    }
    
    func enableKeyboardDismissAction(status: Bool) {
        headerView.enableDismissKeyboardAction(status: status)
    }
    
    func saveData(title: String?, description: String?) {
        if title != nil {
            let timeStampObject = Date()
            do {
                if indexOfCell != nil {
                    notesDataModel.deleteData(row: indexOfCell!)
                }
                try notesDataModel.insertData(title: title!, description: description!, timeStamp: timeStampObject, favoriteStatus: favStatus)
            }catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureData(cellData: Dictionary<String, AnyObject>, cellIndex: Int) {
        self.notesText = cellData["notesText"] as? String
        self.timeStamp = cellData["timeStamp"] as? Date
        self.indexOfCell = cellIndex
        self.favStatus = cellData["favStatus"] as! Bool
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
