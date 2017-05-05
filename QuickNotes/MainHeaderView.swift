//
//  MainHeaderView.swift
//  QuickNotes
//
//  Created by Suruchi Sinha on 4/11/17.
//  Copyright © 2017 Suruchi Sinha. All rights reserved.
//

import UIKit

@objc protocol HeaderViewDelegate {
    @objc optional func launchEditorView()
    @objc optional func dismissViewController()
    @objc optional func dismissKeyboard()
}

class MainHeaderView: UIView {
    
    weak var delegate       : HeaderViewDelegate?
    var addNewActionLabel   : UILabel!
    var titleLabel          : UILabel!
    var backActionLabel     : UILabel!
    var actionLabel         : UILabel!
    var viewHeight          : CGFloat = 0.0
    var viewWidth           : CGFloat = 0.0
    
    init(frame: CGRect, callingClass: CallingClass) {
        super.init(frame: frame)
        viewHeight = frame.size.height
        viewWidth = frame.size.width
        self.backgroundColor = UIColor.appThemeColor
        if callingClass == CallingClass.mainView {
            configureHeaderForMainView()
        }else {
            configureHeaderForEditorView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeaderForMainView() {
        
        var labelwidth  : CGFloat
        var labelheight : CGFloat
        var xPos        : CGFloat
        var yPos        : CGFloat
        let yOffSet     : CGFloat = 20.0
        let xOffSet     : CGFloat = 10.0
        
        labelwidth = 150.0
        labelheight = 20.0
        xPos = (viewWidth - labelwidth) / 2
        yPos = yOffSet + (viewHeight - labelheight - yOffSet) / 2
        titleLabel = UILabel(frame: CGRect(x: xPos, y: yPos, width: labelwidth, height: labelheight))
        titleLabel.text = "QuickNotes"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Verdana", size: 18.0)
        titleLabel.clipsToBounds = true
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.clear
        
        labelwidth = 30.0
        labelheight = 26.0
        xPos = viewWidth - labelwidth - xOffSet
        yPos = titleLabel.frame.maxY - labelheight
        addNewActionLabel = UILabel(frame: CGRect(x: xPos, y: yPos, width: labelwidth, height: labelheight))
        addNewActionLabel.isUserInteractionEnabled = true
        addNewActionLabel.font = UIFont(name: "FontAwesome", size: 26.0)
        addNewActionLabel.text = "\u{f067}"
        addNewActionLabel.backgroundColor = UIColor.clear
        addNewActionLabel.textColor = UIColor.white
        addNewActionLabel.textAlignment = .center
        addNewActionLabel.clipsToBounds = true
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(MainHeaderView.addNewNote))
        addNewActionLabel.addGestureRecognizer(tapAction)
        
        self.addSubview(titleLabel)
        self.addSubview(addNewActionLabel)
    }
    
    func configureHeaderForEditorView() {
        
        let labelHeight : CGFloat = 20.0
        let labelWidth  : CGFloat = 100.0
        var xPos        : CGFloat = 10.0
        let yOffset     : CGFloat = 20.0
        let yPos        : CGFloat = yOffset + (viewHeight - labelHeight - yOffset) / 2
        backActionLabel = UILabel(frame: CGRect(x: xPos, y: yPos, width: labelWidth, height: labelHeight))
        backActionLabel.textColor = UIColor.white
        backActionLabel.text = "\u{f053}"
        backActionLabel.isUserInteractionEnabled = true
        backActionLabel.backgroundColor = UIColor.clear
        backActionLabel.textAlignment = .left
        backActionLabel.clipsToBounds = true
        backActionLabel.font = UIFont(name: "FontAwesome", size: 18.0)
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(MainHeaderView.dismissView))
        backActionLabel.addGestureRecognizer(tapAction)
        
        xPos = viewWidth - labelWidth - xPos
        actionLabel = UILabel(frame: CGRect(x: xPos, y: yPos, width: labelWidth, height: labelHeight))
        actionLabel.textColor = UIColor.white
        actionLabel.text = "Done"
        actionLabel.isUserInteractionEnabled = false
        actionLabel.isHidden = true
        actionLabel.backgroundColor = UIColor.clear
        actionLabel.textAlignment = .right
        actionLabel.font = UIFont(name: "Verdana", size: 18.0)
        let labelAction = UITapGestureRecognizer(target: self, action: #selector(MainHeaderView.dismissKeyboard))
        actionLabel.addGestureRecognizer(labelAction)
        
        self.addSubview(backActionLabel)
        self.addSubview(actionLabel)
    }
    
    func addNewNote(sender: UIGestureRecognizer) {
        if self.delegate != nil {
            self.delegate!.launchEditorView!()
        }
    }
    
    func dismissView(sender: UIGestureRecognizer) {
        if self.delegate != nil {
            self.delegate!.dismissViewController!()
        }
    }
    
    func enableDismissKeyboardAction(status: Bool) {
        if status {
            actionLabel.isUserInteractionEnabled = true
            actionLabel.isHidden = false
        }else {
            actionLabel.isUserInteractionEnabled = false
            actionLabel.isHidden = true
        }
    }
    
    func dismissKeyboard(sender: UIGestureRecognizer) {
        if self.delegate != nil {
            self.delegate!.dismissKeyboard!()
        }
    }

}
