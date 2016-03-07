//
//  DetailCell.swift
//  TransitApp
//
//  Created by Elliott Brunet on 06/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var stopAddressLabel: UILabel!
    @IBOutlet weak var extraInformationLabel: UILabel!
    @IBOutlet weak var detailExtraInformation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
