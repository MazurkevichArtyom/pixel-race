//
//  GameViewController.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 08.02.2022.
//

import UIKit

class GameViewController: UIViewController {
    private var debugTimer: Timer?
    private var gameManager: GameManager?
    
    // GameManager init(VC) - SpawnerManager and CollisionManager
    // VC should know only about GameManager
    // Need to move all animations to GameManager
    // Need to create GameObject with speed proprty
    
    override func loadView() {
        let customView = UIView(frame: UIScreen.main.bounds)
        customView.backgroundColor = .white
        view = customView
        
        setupControlGestures()
        
        let gm = GameManager(viewController: self)
        gm.setupGameScene();
        gameManager = gm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(debugInfo), userInfo: nil, repeats: true)
        
        guard let gameManager = gameManager else {
            return
        }
        
        gameManager.start()
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
    
    private func setupControlGestures() {
        let leftSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        leftSwipeGR.direction = .left
        view.addGestureRecognizer(leftSwipeGR)
        
        let rightSwipeGR = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        rightSwipeGR.direction = .right
        view.addGestureRecognizer(rightSwipeGR)
    }
    
    private func movePlayersCar(direction: UISwipeGestureRecognizer.Direction) {
        guard let gameManager = gameManager else {
            return
        }
        
        switch direction {
        case .left:
            gameManager.movePlayersCar(move: .left)
        case .right:
            gameManager.movePlayersCar(move: .right)
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
