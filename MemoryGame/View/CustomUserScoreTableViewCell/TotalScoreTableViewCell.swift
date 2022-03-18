//
//  TotalScoreTableViewCell.swift
//  MemoryGame
//
//  Created by Tetiana Sierikova on 23.02.2022.
//

import UIKit

class TotalScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var moves: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet var labelsForSort: [UILabel]!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.layer.cornerRadius = 10
    }
}
