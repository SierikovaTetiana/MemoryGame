//
//  UserScoreViewController.swift
//  MemoryGame
//
//  Created by Tetiana Sierikova on 23.02.2022.
//

import UIKit

class UserScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userScoreTable: UITableView!
    @IBOutlet var alternativeView: UIView!
    @IBOutlet weak var backToChoose: UIButton!
    @IBAction func backToChoose(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
    var userData = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userScoreTable.layer.cornerRadius = 15
        userScoreTable.dataSource = self
        userScoreTable.delegate = self
        userScoreTable.register(UINib(nibName: "UserScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "userScoreCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let pageVc = self.parent as? PageViewController {
            userData = pageVc.data
        }
        userScoreTable.reloadData()
        if userData.count == 0 {
            view.addSubview(alternativeView)
            alternativeView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                alternativeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                alternativeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                alternativeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                alternativeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
            backToChoose.layer.cornerRadius = 15
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        alternativeView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return userData.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userScoreCell", for: indexPath) as! UserScoreTableViewCell
        if indexPath.section == 0 {
            cell.movesLabel.text = "Moves"
            cell.pointsLabel.text = "Points"
            cell.timeLabel.text = "Time"
        } else if indexPath.section == 1 {
            cell.movesLabel.text = "\(userData[indexPath.row].moves)"
            cell.pointsLabel.text = "\(userData[indexPath.row].points)"
            cell.timeLabel.text = "\(userData[indexPath.row].time)"
        }
        return cell
    }
}
