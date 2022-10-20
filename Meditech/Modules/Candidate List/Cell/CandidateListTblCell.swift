//
//  CandidateListTblCell.swift
//  Meditech
//
//  Created by shomil on 25/08/22.
//

import UIKit

class CandidateListTblCell: UITableViewCell {
    
    @IBOutlet weak var imgCandidate: UIImageView!
    @IBOutlet weak var lblCandidatePhoneNo: UILabel!
    @IBOutlet weak var lblCandidateEmail: UILabel!
    @IBOutlet weak var lblCandidateName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
