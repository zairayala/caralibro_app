//
//  TVCellChat.swift
//  2022-ios
//
//  Created by user190700 on 7/22/22.
//

import UIKit

class TVCellChat: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var messagepv: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
