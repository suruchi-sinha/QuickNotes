//
//  MainFooterView.swift
//  QuickNotes
//
//  Created by Suruchi Sinha on 4/11/17.
//  Copyright © 2017 Suruchi Sinha. All rights reserved.
//

import UIKit

protocol FooterViewDelegate: NSObjectProtocol {
    func deleteNote()
    func markNoteAsFavourite(selectionStatus: Bool)
}

class MainFooterView: UIView {

    var countLabel: UILabel!
    let favouriteLabel = UILabel()
    var dateLabel = UILabel()
    
    var isFavSelected = false
    weak var footerDelegate: FooterViewDelegate?
    
    init(frame: CGRect, callingClass: CallingClass) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.appThemeColor
        if callingClass == CallingClass.mainView {
            configureFooterForMainView()
        }else {
            configureFooterForEditorView()
        }
    }
    
    override func layoutSubviews() {
        if isFavSelected {
            favouriteLabel.text = "\u{f005}"
        }else {
            favouriteLabel.text = "\u{f006}"
        }
    }
    
    func configureFooterForMainView() {
        var xPos, yPos: CGFloat
        let labelWidth: CGFloat = 100.0
        let labelHeight: CGFloat = 20.0
        
        xPos = (frame.size.width - labelWidth) / 2
        yPos = (frame.size.height - labelHeight) / 2
        countLabel = UILabel(frame: CGRect(x: xPos, y: yPos, width: labelWidth, height: labelHeight))
        countLabel.textColor = UIColor.white
        countLabel.backgroundColor = UIColor.clear
        countLabel.textAlignment = .center
        countLabel.font = UIFont(name: "Verdana", size: 16.0)
        self.addSubview(countLabel)
    }
    
    func configureFooterForEditorView() {
        
        var xPos, yPos: CGFloat
        var labelWidth: CGFloat = 30.0
        let labelHeight: CGFloat = 22.0
        let deleteLabel = UILabel()
        
        let xOffset: CGFloat = 10.0
        var tapGesture: UITapGestureRecognizer
        
        xPos = xOffset
        yPos = (frame.size.height - labelHeight) / 2
        deleteLabel.frame = CGRect(x: xPos, y: yPos, width: labelWidth, height: labelHeight)
        deleteLabel.textColor = UIColor.white
        deleteLabel.backgroundColor = UIColor.clear
        deleteLabel.textAlignment = .left
        deleteLabel.font = UIFont(name: "FontAwesome", size: 22.0)
        deleteLabel.text = "\u{f014}"
        deleteLabel.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainFooterView.deleteNote))
        deleteLabel.addGestureRecognizer(tapGesture)
        self.addSubview(deleteLabel)
        
        xPos = frame.size.width - labelWidth - xOffset
        favouriteLabel.frame = CGRect(x: xPos, y: yPos, width: labelWidth, height: labelHeight)
        favouriteLabel.textColor = UIColor.white
        favouriteLabel.backgroundColor = UIColor.clear
        favouriteLabel.textAlignment = .center
        favouriteLabel.font = UIFont(name: "FontAwesome", size: 22.0)
        favouriteLabel.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainFooterView.markFavorite))
        favouriteLabel.addGestureRecognizer(tapGesture)
        self.addSubview(favouriteLabel)
        
        labelWidth = 200.0
        xPos = (frame.size.width - labelWidth) / 2
        dateLabel.frame = CGRect(x: xPos, y: yPos, width: labelWidth, height: labelHeight)
        dateLabel.textColor = UIColor.white
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "Verdana", size: 14.0)
        self.addSubview(dateLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFooterTimestampLabel(timeStamp: Date?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        var date = timeStamp
        if timeStamp == nil {
            date = Date()
            dateLabel.text = "\(dateFormatter.string(from: date!))"
        }else {
            dateLabel.text = "Edited \(dateFormatter.string(from: date!))"
        }
        
        
    }
    
    func setFooterLabelText(notesCount: Int) {
        var text: String
        switch notesCount {
        case 0:
            text = "No Notes"
        case 1:
            text = "\(notesCount) Note"
        default:
            text = "\(notesCount) Notes"
        }
        countLabel.text = text
    }
    
    func deleteNote(sender: UIGestureRecognizer) {
        if self.footerDelegate != nil {
            self.footerDelegate?.deleteNote()
        }
    }
    
    func markFavorite(sender: UIGestureRecognizer) {
        if self.footerDelegate != nil {
            if self.isFavSelected {
                self.favouriteLabel.text = "\u{f006}"
                self.isFavSelected = false
            }else {
                self.favouriteLabel.text = "\u{f005}"
                self.isFavSelected = true
            }
            self.footerDelegate?.markNoteAsFavourite(selectionStatus: self.isFavSelected)
        }
    }

}
