//
//  PageViewController.swift
//  MemoryGame
//
//  Created by Tetiana Sierikova on 23.02.2022.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var subViewControllers: [UIViewController] = {
        return [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserScoreViewController") as! UserScoreViewController,
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TotalScoreViewController") as! TotalScoreViewController
        ]
    }()
    lazy var appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    
    var data = [UserData]()
    var totalData: [TotalData] = [TotalData(playerName: "Player1", moves: 5, points: 12, time: 7), TotalData(playerName: "Player2", moves: 4, points: 8, time: 17), TotalData(playerName: "Player3", moves: 3, points: 6, time: 7), TotalData(playerName: "Player4", moves: 5, points: 10, time: 9), TotalData(playerName: "Player5", moves: 17, points: 2, time: 7)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setViewControllers([ subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        appearance.pageIndicatorTintColor = UIColor.lightGray
        appearance.currentPageIndicatorTintColor = UIColor.red
        appearance.preferredIndicatorImage = UIImage(systemName: "heart.fill")
    }
    
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            }
        }
        super.viewDidLayoutSubviews()
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex >= (subViewControllers.count - 1)  {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
    
    func presentationIndex(for pvc: UIPageViewController) -> Int {
        guard let currentVC = viewControllers else { return  0 }
        if let currentVC = currentVC.first {
            guard let currentIndex = subViewControllers.firstIndex(of: currentVC) else { return 0 }
            return currentIndex
        } else {
            return 0
        }
    }
}
