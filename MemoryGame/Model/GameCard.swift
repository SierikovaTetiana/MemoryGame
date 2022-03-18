//
//  gameCard.swift
//  MemoryGame
//
//  Created by Tetiana Sierikova on 21.02.2022.

//

import UIKit

struct GameCard {
    var id: Int = 0
    var image: UIImage = UIImage(named: "love_is") ?? UIImage(systemName: "scope")!
}

struct UserData {
    var moves: Int = 0
    var points: Int = 0
    var time: Int = 0
}

struct TotalData {
    var playerName: String = ""
    var moves: Int = 0
    var points: Int = 0
    var time: Int = 0
}

struct TotalTitleTable {
    var userName: String = "Player Name"
    var moves: String = "Moves"
    var points: String = "Points"
    var time: String = "Time"
}
