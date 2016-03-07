//
//  RouteGeneralCell.swift
//  TransitApp
//
//  Created by Elliott Brunet on 06/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit

class RouteGeneralCell: UITableViewCell {

    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var transportTypeLabel: UILabel!    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationDetailLabel: UILabel!
    @IBOutlet weak var graphicPresentationImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
