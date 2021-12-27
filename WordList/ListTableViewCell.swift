//
//  ListTableViewCell.swift
//  WordList
//
//  Created by Owner on 2021/12/27.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var englishLabel:UILabel!
    @IBOutlet var japaneseLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
