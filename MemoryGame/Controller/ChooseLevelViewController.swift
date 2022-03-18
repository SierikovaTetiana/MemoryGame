//
//  ViewController.swift
//  MemoryGame
//
//  Created by Tetiana Sierikova on 21.02.2022.
//

import UIKit

class ChooseLevelViewController: UIViewController {

    @IBOutlet var chooseLevel: [UIButton]!
    @IBAction func levelButtonTapped(_ sender: UIButton) {
        if let levelLabel = sender.titleLabel {
            if let levelLabelText = levelLabel.text {
                chosenLevel = levelLabelText
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ChooseLevelToGame", sender: self)
                }
            }
        }
    }
    
    private var chosenLevel: String = ""
    var userData = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in chooseLevel {
            button.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let gameVC = self.parent as? GameViewController {
            userData = gameVC.userData
        }
        if let destinationVC = self.tabBarController?.children.last as? PageViewController {
            destinationVC.data = self.userData
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseLevelToGame" {
            if let vc = segue.destination as? GameViewController {
                vc.chosenLevel = chosenLevel
                vc.userData = userData
            }
        }
    }
}
