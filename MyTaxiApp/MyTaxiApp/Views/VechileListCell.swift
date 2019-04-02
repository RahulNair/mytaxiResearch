//
//  VechileListCell.swift
//  MyTaxiApp
//
//  Created by Rahul Nair on 02/04/19.
//  Copyright © 2019 Rahul. All rights reserved.
//

import UIKit

class VechileListCell: UITableViewCell {

    @IBOutlet weak var bearingDirection: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValueForCell (model : MTVechileDataModel){
        self.typeLabel.text = model.vh_type
        self.statusLabel.text = model.state
        self.bearingDirection.text = MTAppUtil.getDirectionText(bearingValue: model.heading)
    }
    
    override func prepareForReuse() {
        self.bearingDirection.text = ""
        self.iconImageView.image = nil
        self.typeLabel.text = "0"
        self.statusLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
