//
//  ViewControllerTableViewCell.swift
//  2022-ios
//
//  Created by user190700 on 7/18/22.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var userlbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!    
    @IBOutlet weak var loadMessage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
