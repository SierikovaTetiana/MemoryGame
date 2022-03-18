//
//  TotalScoreViewController.swift
//  MemoryGame
//
//  Created by Tetiana Sierikova on 23.02.2022.
//

import UIKit

class TotalScoreViewController: UIViewController {

    @IBOutlet weak var totalScoreTable: UITableView!
    
    private var totalData = [TotalData]()
    private var userData = [UserData]()
    private var sortedTotalData = [TotalData]()
    private var titleTable = [TotalTitleTable(userName: "Player Name", moves: "Moves", points: "Points", time: "Time")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalScoreTable.layer.cornerRadius = 15
        totalScoreTable.dataSource = self
        totalScoreTable.delegate = self
        totalScoreTable.register(UINib(nibName: "TotalScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "totalScoreCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let pageVc = self.parent as? PageViewController {
            totalData = pageVc.totalData
            userData = pageVc.data
        }
        sortData()
    }
    
 
    // MARK: - Sort data
    
    @objc func handleTapToMoves(_ sender: UIGestureRecognizer) {
        if !titleTable[0].moves.contains("↓") {
            titleTable[0].moves.append("↓")
        } else {
            titleTable[0].moves.removeLast()
        }
        titleTable[0].points.removeAll(where: { $0 == "↓" })
        titleTable[0].time.removeAll(where: { $0 == "↓" })
        totalData.removeAll(where: { $0.playerName == "YOU" })
        if let maxUserMoves = (userData.min { $0.moves < $1.moves }) {
            totalData.append(TotalData(playerName: "YOU", moves: maxUserMoves.moves, points: maxUserMoves.points, time: maxUserMoves.time))
        }
        sortedTotalData = totalData.sorted { $0.moves < $1.moves }
        managePointer()
    }
    
    @objc func handleTapToPoints(_ sender: UIGestureRecognizer) {
        if !titleTable[0].points.contains("↓") {
            titleTable[0].points.append("↓")
        } else {
            titleTable[0].points.removeLast()
        }
        titleTable[0].moves.removeAll(where: { $0 == "↓" })
        titleTable[0].time.removeAll(where: { $0 == "↓" })
        totalData.removeAll(where: { $0.playerName == "YOU" })
        if let maxUserPoint = (userData.max { $0.points < $1.points }) {
            totalData.append(TotalData(playerName: "YOU", moves: maxUserPoint.moves, points: maxUserPoint.points, time: maxUserPoint.time))
        }
        sortedTotalData = totalData.sorted { $0.points > $1.points }
        managePointer()
    }
    
    @objc func handleTapToTime(_ sender: UIGestureRecognizer) {
        if !titleTable[0].time.contains("↓") {
            titleTable[0].time.append("↓")
        } else {
            titleTable[0].time.removeLast()
        }
        titleTable[0].points.removeAll(where: { $0 == "↓" })
        titleTable[0].moves.removeAll(where: { $0 == "↓" })
        totalData.removeAll(where: { $0.playerName == "YOU" })
        if let maxUserTime = (userData.min { $0.time < $1.time }) {
            totalData.append(TotalData(playerName: "YOU", moves: maxUserTime.moves, points: maxUserTime.points, time: maxUserTime.time))
        }
        sortedTotalData = totalData.sorted { $0.time < $1.time }
        managePointer()
    }
    
    private func sortData() {
        if !titleTable[0].points.contains("↓") {
            titleTable[0].points.append("↓")
        }
        totalData.removeAll(where: { $0.playerName == "YOU" })
        if let maxUserPoint = (userData.max { $0.points < $1.points }) {
            totalData.append(TotalData(playerName: "YOU", moves: maxUserPoint.moves, points: maxUserPoint.points, time: maxUserPoint.time))
        }
        sortedTotalData = totalData.sorted { $0.points > $1.points }
        totalScoreTable.reloadData()
    }
    
    private func managePointer() {
        totalScoreTable.reloadData()
        if !titleTable[0].time.contains("↓") && !titleTable[0].points.contains("↓") && !titleTable[0].moves.contains("↓") {
            sortData()
        }
    }
}

    // MARK: - TableView Delegate

extension TotalScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return sortedTotalData.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "totalScoreCell", for: indexPath) as? TotalScoreTableViewCell else { return UITableViewCell() }
        let tapToMoves = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToMoves(_:)))
        let tapToPoints = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToPoints(_:)))
        let tapToTime = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToTime(_:)))
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.userName.text = titleTable[0].userName
            cell.moves.text = titleTable[0].moves
            cell.points.text = titleTable[0].points
            cell.time.text = titleTable[0].time
            
            cell.moves.addGestureRecognizer(tapToMoves)
            cell.points.addGestureRecognizer(tapToPoints)
            cell.time.addGestureRecognizer(tapToTime)
            
        } else {
            cell.userName.text = "\(sortedTotalData[indexPath.row].playerName)"
            cell.moves.text = "\(sortedTotalData[indexPath.row].moves)"
            cell.points.text = "\(sortedTotalData[indexPath.row].points)"
            cell.time.text = "\(sortedTotalData[indexPath.row].time)"
        }
        return cell
    }
}
