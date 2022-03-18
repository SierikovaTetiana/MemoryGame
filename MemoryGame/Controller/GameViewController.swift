//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Tetiana Sierikova on 21.02.2022.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private enum difficultyLevel: Int {
        case easy = 6
        case medium = 8
        case hard = 10
    }
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var chosenLevel: String = ""
    var userData = [UserData]()
    private var points: Int = 0
    private var moves: Int = 0
    private var minute: Int = 59
    private var timer = Timer()
    private var gameCard = [GameCard]()
    private var setOfpictures: Set<UIImage> = []
    private var selectedPicture = GameCard()
    private var selectedImageIndexPath = IndexPath()
    private var openedCardsIndexPath = [IndexPath]()
    private let defaultBackImage = UIImage(named: "love_is")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib.init(nibName: "GameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        getArrayOfRandomImages()
        startGame()
    }
    
    // MARK: - Manage CollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameCard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCollectionViewCell else { return UICollectionViewCell() }
        if openedCardsIndexPath.contains(where: { $0 == indexPath }) {
            cell.pictureCell.image = gameCard[indexPath.row].image
        } else {
            cell.pictureCell.image = defaultBackImage
        }
        cell.transform = CGAffineTransform(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: 0.0, ty: 0.0)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateMoves()
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCollectionViewCell else { return }
        if selectedPicture.image == gameCard[indexPath.row].image {
            if selectedPicture.image != defaultBackImage {
                if selectedPicture.id != gameCard[indexPath.row].id {
                    self.gameCard.removeAll(where: { $0.image == self.selectedPicture.image })
                    self.openedCardsIndexPath.removeAll()
                    collectionView.reloadData()
                    self.updateScore()
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                        collectionView.cellForItem(at: self.selectedImageIndexPath)?.alpha = 0
                        collectionView.cellForItem(at: indexPath)?.alpha = 0
                    }, completion: nil)

                } else if selectedPicture.id == gameCard[indexPath.row].id {
                    guard let defaultBackImg = defaultBackImage else { return }
                    cell.pictureCell.image = defaultBackImage
                    self.selectedPicture.image = defaultBackImg
                    UIView.animate(withDuration: 0.5, animations: { cell.transform3D = CATransform3DMakeScale(1, 1, 1) }, completion: nil)
                }
            } else if selectedPicture.image == defaultBackImage {
                cell.pictureCell.image = self.gameCard[indexPath.row].image
                selectedPicture.image = self.gameCard[indexPath.row].image
            }
        } else {
            selectedPicture = GameCard(id: gameCard[indexPath.row].id, image: gameCard[indexPath.row].image)
            selectedImageIndexPath = indexPath
            if !openedCardsIndexPath.contains(where: { indexPath == $0 }) {
                openedCardsIndexPath.append(indexPath)
            }
            cell.pictureCell.image = self.gameCard[indexPath.row].image
            UIView.animate(withDuration: 0.5, animations: { cell.transform3D = CATransform3DMakeScale(-1, 1, 1) }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if openedCardsIndexPath.count >= 2  {
            if let firstIndexOfArray = openedCardsIndexPath.first {
                guard let cell = collectionView.cellForItem(at: firstIndexOfArray) as? GameCollectionViewCell else { return }
                cell.pictureCell.image = defaultBackImage
                if let cellForClose = collectionView.cellForItem(at: firstIndexOfArray) as? GameCollectionViewCell {
                    UIView.animate(withDuration: 0.5, animations: { cellForClose.transform3D = CATransform3DMakeScale(1, 1, 1) }, completion: nil)
                }
                openedCardsIndexPath.removeFirst()
            }
        }
    }
    
    // MARK: - CollectionView Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        return CGSize(width: width * 0.4, height: width * 0.4)
    }
    
    // MARK: - Animation
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCell(cell: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animateCell(cell: cell)
    }
    
    private func animateCell(cell: UICollectionViewCell) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        cell.layer.add(animation, forKey: "fade")
    }
    
    // MARK: - Append gameCard by random images from set
    
    private func getArrayOfRandomImages() {
        if chosenLevel == "MEDIUM" {
            randomImg(difficultyLevel: difficultyLevel.medium.rawValue)
            mixImages(difficultyLevel: difficultyLevel.medium.rawValue)
        } else if chosenLevel == "HARD" {
            randomImg(difficultyLevel: difficultyLevel.hard.rawValue)
            mixImages(difficultyLevel: difficultyLevel.hard.rawValue)
        } else {
            randomImg(difficultyLevel: difficultyLevel.easy.rawValue)
            mixImages(difficultyLevel: difficultyLevel.easy.rawValue)
        }
    }
    
    private func mixImages(difficultyLevel: Int) {
        var mixSet1 = Set<UIImage>()
        var mixSet2 = Set<UIImage>()
        while mixSet1.count < difficultyLevel / 2 {
            let randomIndex = setOfpictures.index(setOfpictures.startIndex, offsetBy: Int(arc4random_uniform(UInt32(setOfpictures.count))))
            mixSet1.insert(setOfpictures[randomIndex])
        }
        while mixSet2.count < difficultyLevel / 2 {
            let randomIndex = setOfpictures.index(setOfpictures.startIndex, offsetBy: Int(arc4random_uniform(UInt32(setOfpictures.count))))
            mixSet2.insert(setOfpictures[randomIndex])
        }
        _ = mixSet1.map({ gameCard.append(GameCard(id: 1, image: $0)) })
        _ = mixSet2.map({ gameCard.append(GameCard(id: 2, image: $0)) })
    }
    
    // MARK: - Get random images from folder
    
    private func randomImg(difficultyLevel: Int) {
        let numberOfImages: UInt32 = 46
        while setOfpictures.count < difficultyLevel / 2 {
            let random = arc4random_uniform(numberOfImages)
            let imageName = "love_is_\(random)"
            if let image = UIImage(named: imageName) {
                setOfpictures.insert(image)
            }
        }
    }
    
    // MARK: - Update score
   
    private func updateScore() {
        points += 2
        pointsLabel.text = "\(points)"
    }
    
    private func updateMoves() {
        moves += 1
        movesLabel.text = "\(moves)"
    }

    @objc private func updateTimer() {
        if (minute > 0) {
            let minutes = String("0\(minute / 60)")
            var seconds = String(minute % 60)
            
            if minute % 60 < 10 {
                seconds = "0\(minute % 60)"
            }
            
            timeLabel.text = minutes + ":" + seconds
            minute -= 1
            if chosenLevel == "MEDIUM" {
                if points == difficultyLevel.medium.rawValue {
                    timer.invalidate()
                    finishGameWin()
                }
            } else if chosenLevel == "HARD" {
                if points == difficultyLevel.hard.rawValue {
                    timer.invalidate()
                    finishGameWin()
                }
            } else {
                if points == difficultyLevel.easy.rawValue {
                    timer.invalidate()
                    finishGameWin()
                }
            }
        } else if minute == 0 {
            timer.invalidate()
            finishGameLose()
        }
    }
    
    // MARK: - Finish/start game alert
    
    private func startGame() {
        let alert = UIAlertController(title: "Start game", message: "After 'start' tapping game will start. You will have 1 minute for finish it", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "START", style: .default, handler: {(_) in
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }))
        alert.addAction(UIAlertAction(title: "Not now", style: .cancel, handler: {(_) in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func finishGameLose() {
        setAlert(title: "Time is over:(((", message: "Maybe you'll win next time. Do you want to try?", titleButton: "TRY ONE MORE TIME")
        updateData()
    }
    
    private func finishGameWin() {
        setAlert(title: "Congratulations!! You are winner!)", message: "Maybe you want play one more time?", titleButton: "PLAY")
        updateData()
    }
    
    private func setAlert(title: String, message: String, titleButton: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "PLAY", style: .default, handler: {(_) in
            self.reset()
        }))
        alert.addAction(UIAlertAction(title: "Not now", style: .cancel, handler: {(_) in
            _ = self.navigationController?.popToRootViewController(animated: true)
            self.passDataToPageViewController()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func reset() {
        self.points = 0
        self.moves = 0
        self.minute = 59
        self.timer = Timer()
        self.gameCard = [GameCard]()
        self.setOfpictures = []
        self.selectedPicture = GameCard()
        self.selectedImageIndexPath = IndexPath()
        self.openedCardsIndexPath = [IndexPath]()
        self.getArrayOfRandomImages()
        self.startGame()
        self.collectionView.reloadData()
    }
    
    // MARK: - Manage and pass data
    
    private func passDataToPageViewController() {
        if let chooseLevelVC = self.navigationController?.children.first as? ChooseLevelViewController {
            chooseLevelVC.userData = self.userData
        }
    }
    
    private func updateData() {
        userData.append(UserData(moves: moves, points: points, time: 59 - minute))
    }
}
