//
//  ViewController.swift
//  QuickNotes
//
//  Created by Suruchi Sinha on 10/04/17.
//  Copyright © 2017 Suruchi Sinha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HeaderViewDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Properties
    /// The cell identifier
    let cellIdentifier = "NotesCellIdentifier"
    /// The header view.
    var headerView          : MainHeaderView!
    /// The view containing the list view.
    var contentView         : UIView!
    /// The footer view.
    var footerView          : MainFooterView!
    /// The list view.
    var contentListView     : UITableView!
    /// The width of screen.
    var screenWidth         : CGFloat = 0.0
    /// The height of screen.
    var screenHeight        : CGFloat = 0.0
    /// The height of header view.
    let headerViewHeight    : CGFloat = 60.0
    /// The height of footer view.
    let footerViewHeight    : CGFloat = 40.0
    /// The data model object
    let notesDataModel = NotesDataModel()
    /// List of notes
    var notesData = [Dictionary<String, AnyObject>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = view.bounds.size.width
        screenHeight = view.bounds.size.height
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableData()
    }
    
    func reloadTableData() {
        notesData = notesDataModel.fetchData()!
        if ((contentListView.superview) != nil) {
            contentListView.reloadData()
        }
        footerView.setFooterLabelText(notesCount: notesData.count)

    }
    
    /// This method sets up the header view, content view, and footer view of the main view.
    func setupView() {
        notesData = notesDataModel.fetchData()!
        setupHeaderView()
        setupContentView()
        setupFooterView()
    }
    
    /// This method configures the header view.
    func setupHeaderView() {
        let xPos: CGFloat = 0.0
        let yPos: CGFloat = 0.0
        
        headerView = MainHeaderView(frame: CGRect(x: xPos, y: yPos, width: screenWidth, height: headerViewHeight), callingClass: .mainView)
        headerView.delegate = self
        view.addSubview(headerView)
    }
    
    /// This method configures the content view with the list view.
    func setupContentView() {
        var yPos, viewHeight: CGFloat
        
        yPos = headerView.frame.maxY
        viewHeight = screenHeight - headerViewHeight - footerViewHeight
        contentView = UIView(frame: CGRect(x: 0, y: yPos, width: screenWidth, height: viewHeight))
        contentListView = UITableView(frame: contentView.bounds, style:UITableViewStyle.plain)
        contentListView.delegate = self
        contentListView.dataSource = self
        contentListView.separatorStyle = .none
        contentListView.showsVerticalScrollIndicator = false
        contentListView.backgroundColor = UIColor(colorLiteralRed: 240.0/255.0, green: 237.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        contentListView.register(UINib(nibName: "NotesListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        contentView.addSubview(contentListView)
        view.addSubview(contentView)
    }
    
    /// This method configures the footer view.
    func setupFooterView() {
        let yPos = contentView.frame.maxY
        footerView = MainFooterView(frame: CGRect(x: 0, y: yPos, width: screenWidth, height: footerViewHeight), callingClass: .mainView)
        footerView.setFooterLabelText(notesCount: notesData.count)
        view.addSubview(footerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK - HEADERVIEW DELEGATES
    func launchEditorView() {
        let editorViewController = EditorViewController()
        self.present(editorViewController, animated: true, completion: nil)
    }
    
    //MARK: - TABLEVIEW DELEGATES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NotesListCell
        if cell == nil {
            cell = NotesListCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }
        cell?.configureViewWithData(cellData: notesData[indexPath.section])
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notesData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 0.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = notesData[indexPath.section]
        let editorViewController = EditorViewController()
        editorViewController.configureData(cellData: data, cellIndex: indexPath.section)
        self.present(editorViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notesDataModel.deleteData(row: indexPath.section)
            reloadTableData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.appThemeColor
        return footer
    }
}

