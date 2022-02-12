//
//  GameViewController.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 08.02.2022.
//

import UIKit

class GameViewController: UIViewController {
    private var debugTimer: Timer?

    override func loadView() {
        let customView = UIView(frame: UIScreen.main.bounds)
        customView.backgroundColor = .darkGray
        view = customView
        
        setupControlGestures()
        setupGameScene();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(debugInfo), userInfo: nil, repeats: true)
        
        SpawnerManager.shared.startLaneSeparatorsSpawning()
        SpawnerManager.shared.startSideObjectsSpawning()
        SpawnerManager.shared.startTrafficFlowSpawning()
        CollisionManager.shared.startObserving() {
            SpawnerManager.shared.invalidate()
            CollisionManager.shared.stopObserving()
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        debugTimer?.invalidate()
    }
    
    private func setupGameScene() {
        SpawnerManager.shared.setupViewController(viewController: self)
        SpawnerManager.shared.setupRacingLocation()
    }
    
    private func setupControlGestures() {
        let leftSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        leftSwipeGR.direction = .left
        view.addGestureRecognizer(leftSwipeGR)
        
        let rightSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        rightSwipeGR.direction = .right
        view.addGestureRecognizer(rightSwipeGR)
    }
    
    private func movePlayersCar(direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .left:
            GameManager.shared.movePlayersCar(move: .left)
        case .right:
            GameManager.shared.movePlayersCar(move: .right)
        default: break
        }
    }
    
    @objc private func onSwipe(gesture: UISwipeGestureRecognizer) {
        movePlayersCar(direction: gesture.direction)
    }
    
    @objc private func debugInfo() {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
