//
//  SampleTableCell.swift
//  Venkat Reddy
//
//  Created by ojas on 18/12/19.
//  Copyright © 2019 ojas. All rights reserved.
//

import UIKit

class SampleTableCell: UITableViewCell {

    
    @IBOutlet weak var lbl_title : UILabel!
    @IBOutlet weak var lbl_date : UILabel!
    
    var delegate : Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbl_title.text = ""
        lbl_title.numberOfLines = 0
        lbl_title.lineBreakMode = .byWordWrapping
        
        lbl_date.text = ""
        lbl_date.numberOfLines = 0
        lbl_date.lineBreakMode = .byWordWrapping

    }

    
    func setDataToSampleTableCell(data: NSDictionary , delegate : Any , indexpath : IndexPath)
    {
        self.delegate = delegate
        
        if let title = data.object(forKey: "title") as? String , !title.isEmpty
        {
            lbl_title.text = title
        }
        
        if let date = data.object(forKey: "created_at") as? String , !date.isEmpty
        {
            lbl_date.text = Date().formatDateString(dateString: date)
        }
    }
}
