//
//  OptionTableViewCell.swift
//  The Wheely Cool App
//
//  Created by Hasitha De Mel on 20/12/21.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    static let cellIdentifier = "OptionsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setup(option: String) {
        textLabel?.text = option
    }
    
}
