//
//  NotesListCell.swift
//  QuickNotes
//
//  Created by Suruchi Sinha on 10/04/17.
//  Copyright © 2017 Suruchi Sinha. All rights reserved.
//

import UIKit

class NotesListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .default
    }
    
    func configureViewWithData(cellData: Dictionary<String, AnyObject>) {
        let description = cellData["notesText"] as! String
        let date = cellData["timeStamp"] as! Date
        let status = cellData["favStatus"] as! Bool
        let dateFormatter = DateFormatter()
        titleLabel.text = cellData["title"] as? String
        let formattedText = description.replacingOccurrences(of: titleLabel.text!, with: "")
        descriptionLabel.text = formattedText.trimmingCharacters(in: .whitespacesAndNewlines)
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        timestampLabel.text = dateFormatter.string(from: date)
        
        if status {
            favStatus.text = "\u{f005}"
            favStatus.isHidden = false
        }else {
            favStatus.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
