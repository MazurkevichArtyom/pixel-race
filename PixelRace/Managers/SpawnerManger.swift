//
//  SpawnerManger.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 11.02.2022.
//

import Foundation
import UIKit

class SpawnerManager {
    static let shared = SpawnerManager()
    
    var playersCar: UIImageView?

    private var gameViewController: UIViewController?
    
    private let sideColor = UIColor(hex: 0x76AC1F)
    private let laneColor = UIColor(hex: 0xA0A0A0)
    private let sideSeparatorColor = UIColor(hex: 0x787878)
    private let separateLineColor = UIColor.white
    
    private var viewSize: CGSize?
    private var sideAreaSize: CGSize?
    private var roadLaneSize: CGSize?
    private var carSize: CGSize?
    private var truckSize: CGSize?
    private var treeSize: CGSize?
    private var bushSize: CGSize?
    private var separateLineSize: CGSize?
    
    private var laneSeparatorsTimer: Timer?
    private var leftSideItemsTimer: Timer?
    private var rightSideItemsTimer: Timer?
    private var trafficFlowTimer: Timer?
    
    private var cachedCivilCars: [Lane: [UIImageView]] = [.left: [UIImageView](), .middle: [UIImageView](), .right: [UIImageView]()]
    private var cachedTrucks: [Lane: [UIImageView]] = [.left: [UIImageView](), .middle: [UIImageView](), .right: [UIImageView]()]
    private var cachedTrees: [Side: [UIImageView]] = [.left: [UIImageView](), .right :[UIImageView]()]
    private var cachedBushes: [Side: [UIImageView]] = [.left: [UIImageView](), .right :[UIImageView]()]
    private var cachedLaneSeparators: [Side: [UIView]] = [.left: [UIView](), .right :[UIView]()]
    
    func setupViewController(viewController: UIViewController) {
        gameViewController = viewController
        cofigureObjectSizes(viewSize: viewController.view.frame.size)
    }
    
    func setupRacingLocation() {
        generateSide(side: .left)
        generateSide(side: .right)
        
        generateLane(type: .left)
        generateLane(type: .middle)
        generateLane(type: .right)
        
        generateSideSeparator(side: .left)
        generateSideSeparator(side: .right)
        
        generatePlyersCar()
    }
    
    func invalidate() {
        laneSeparatorsTimer?.invalidate()
        leftSideItemsTimer?.invalidate()
        rightSideItemsTimer?.invalidate()
        trafficFlowTimer?.invalidate()
        
        guard let viewController = gameViewController else {
            return
        }
        viewController.view.layer.removeAllAnimations()
        
        clearAllCachedData()
    }
    
    func startLaneSeparatorsSpawning() {
        restartLaneSeparatorsTimer()
    }
    
    func startSideObjectsSpawning() {
        restartLeftSideItemsTimer()
        restartRightSideItemsTimer()
    }
    
    func startTrafficFlowSpawning() {
        restartTrafficFlowTimer()
    }
    
    private func restartLaneSeparatorsTimer() {
        laneSeparatorsTimer?.invalidate()
        laneSeparatorsTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(genereateLaneSeparators), userInfo: nil, repeats: true)
    }
    
    private func restartLeftSideItemsTimer() {
        leftSideItemsTimer?.invalidate()
        leftSideItemsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.3...1.0), target: self, selector: #selector(generateLeftSideItems), userInfo: nil, repeats: false)
    }
    
    private func restartRightSideItemsTimer() {
        rightSideItemsTimer?.invalidate()
        rightSideItemsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.3...1.0), target: self, selector: #selector(generateRightSideItems), userInfo: nil, repeats: false)
    }
    
    private func restartTrafficFlowTimer() {
        trafficFlowTimer?.invalidate()
        trafficFlowTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.5...1.0), target: self, selector: #selector(generateEnemysCars), userInfo: nil, repeats: false)
    }
    
    private func clearAllCachedData() {
        for item in cachedCivilCars {
            for object in item.value {
                object.removeFromSuperview()
            }
        }
        
        cachedCivilCars = [.left: [UIImageView](), .middle: [UIImageView](), .right: [UIImageView]()]
        
        for item in cachedTrucks {
            for object in item.value {
                object.removeFromSuperview()
            }
        }
        
        cachedTrucks = [.left: [UIImageView](), .middle: [UIImageView](), .right: [UIImageView]()]
        
        for item in cachedTrees {
            for object in item.value {
                object.removeFromSuperview()
            }
        }
        
        cachedTrees = [.left: [UIImageView](), .right :[UIImageView]()]
        
        for item in cachedBushes {
            for object in item.value {
                object.removeFromSuperview()
            }
        }
        
        cachedBushes = [.left: [UIImageView](), .right :[UIImageView]()]
        
        for item in cachedLaneSeparators {
            for object in item.value {
                object.removeFromSuperview()
            }
        }
        
        cachedLaneSeparators = [.left: [UIView](), .right :[UIView]()]
    }
    
    @objc private func genereateLaneSeparators() {
        guard let viewController = gameViewController else {
            return
        }
        
        guard let leftLaneSeparator = generateLaneSeparator(side: .left) else {
            return
        }
        
        guard let rightLaneSeparator = generateLaneSeparator(side: .right) else {
            return
        }
        
        let leftLaneInitialCenter = leftLaneSeparator.center
        let rightLaneInitialCenter = rightLaneSeparator.center
        
        UIView.animate(withDuration: 2.5, delay: 0, options: .curveLinear) {
            leftLaneSeparator.center = CGPoint(x: leftLaneSeparator.center.x , y: viewController.view.frame.height + leftLaneSeparator.frame.height)
            rightLaneSeparator.center = CGPoint(x: rightLaneSeparator.center.x , y: viewController.view.frame.height + rightLaneSeparator.frame.height)
        } completion: { finish in
            leftLaneSeparator.center = leftLaneInitialCenter
            rightLaneSeparator.center = rightLaneInitialCenter
            leftLaneSeparator.isHidden = true
            rightLaneSeparator.isHidden = true
        }
    }
    
    @objc private func generateRightSideItems() {
        addAndAnimateSideItem(side: .right)
        restartRightSideItemsTimer()
    }
    
    @objc private func generateLeftSideItems() {
        addAndAnimateSideItem(side: .left)
        restartLeftSideItemsTimer()
    }
    
    @objc private func generateEnemysCars() {
        guard let viewController = gameViewController else {
            return
        }
        
        guard let vehicle = generateRandomVehicle() else {
            return
        }
        
        let enemysCarInitialCenter = vehicle.center
        
        CollisionManager.shared.addObservableObject(observable: vehicle)
                
        UIView.animate(withDuration: vehicle.accessibilityIdentifier == "truck" ? 2.3 : 2, delay: 0, options: .curveLinear) {
            vehicle.center = CGPoint(x: vehicle.center.x, y: viewController.view.frame.height + vehicle.frame.height)
        } completion: { finish in
            vehicle.center = enemysCarInitialCenter
            vehicle.isHidden = true
            CollisionManager.shared.removeObservableObject(observable: vehicle)
        }
        
        restartTrafficFlowTimer()
    }
    
    private func addAndAnimateSideItem(side: Side) {
        guard let viewController = gameViewController else {
            return
        }
        
        guard let sideObject = generateRandomSideItem(side: side) else {
            return
        }
        
        let sideObjectInitialCenter = sideObject.center
        
        UIView.animate(withDuration: 2.5, delay: 0, options: .curveLinear) {
            sideObject.center = CGPoint(x: sideObject.center.x, y: viewController.view.frame.height + sideObject.frame.height)
        } completion: { finish in
            sideObject.center = sideObjectInitialCenter
            sideObject.isHidden = true
        }
    }
    
    private func generateSide(side: Side) {
        guard let sideArea = sideAreaSize else {
            return
        }
        
        guard let view = viewSize else {
            return
        }
        
        guard let viewController = gameViewController else {
            return
        }
        
        let side = UIView(frame: CGRect(x: side == .left ? 0 : view.width - sideArea.width, y: 0, width: sideArea.width, height: sideArea.height))
        side.backgroundColor = sideColor
        side.isUserInteractionEnabled = false
        
        viewController.view.addSubview(side)
    }
    
    private func generateLane(type: Lane) {
        guard let roadLane = roadLaneSize else {
            return
        }
        
        guard let sideArea = sideAreaSize else {
            return
        }
        
        guard let viewController = gameViewController else {
            return
        }
        
        var laneX: Double = 0
        
        switch type {
        case .left:
            laneX = sideArea.width
        case .middle:
            laneX = sideArea.width + roadLane.width
        case .right:
            laneX = sideArea.width + 2 * roadLane.width
        }
        
        let lane = UIView(frame: CGRect(x: laneX, y: 0, width: roadLane.width, height: roadLane.height))
        lane.backgroundColor = laneColor
        lane.isUserInteractionEnabled = false
        
        viewController.view.addSubview(lane)
    }
    
    private func generateSideSeparator(side: Side) {
        guard let sideArea = sideAreaSize else {
            return
        }
        
        guard let roadLane = roadLaneSize else {
            return
        }
        
        guard let separateLine = separateLineSize else {
            return
        }
        
        guard let view = viewSize else {
            return
        }
        
        guard let viewController = gameViewController else {
            return
        }
        
        var lineX: Double = 0

        switch side {
        case .left:
            lineX = sideArea.width - separateLine.width / 2.0
        case .right:
            lineX = sideArea.width + 3 * roadLane.width - separateLine.width / 2.0
        }

        let line = UIView(frame: CGRect(x: lineX, y: 0, width: separateLine.width, height: view.height))
        line.backgroundColor = sideSeparatorColor
        line.isUserInteractionEnabled = false

        viewController.view.addSubview(line)
    }

    private func generatePlyersCar() {
        guard let sideArea = sideAreaSize else {
            return
        }
        
        guard let roadLane = roadLaneSize else {
            return
        }
        
        guard let car = carSize else {
            return
        }
        
        guard let view = viewSize else {
            return
        }
        
        guard let viewController = gameViewController else {
            return
        }
        
        let myCar = UIImageView(frame: CGRect(x: sideArea.width + roadLane.width + (roadLane.width - car.width) / 2.0 , y: view.height - 120.0, width: car.width, height: car.height))
        myCar.contentMode = .scaleAspectFit
        myCar.isUserInteractionEnabled = false
        let image = UIImage(named: "player_car")
        myCar.image = image
        myCar.layer.zPosition = 10
        myCar.applyShadow(offset: CGSize(width: 4, height: 3), radius: 7)

        playersCar = myCar

        viewController.view.addSubview(myCar)
    }
    
    
    private func generateLaneSeparator(side: Side) -> UIView? {
        if let createdSeparator = cachedLaneSeparators[side]?.first(where: { view in
            return view.isHidden
        })
        {
            createdSeparator.isHidden = false
            return createdSeparator
        }
        
        guard let sideArea = sideAreaSize else {
            return nil
        }
        
        guard let roadLane = roadLaneSize else {
            return nil
        }
        
        guard let separateLine = separateLineSize else {
            return nil
        }
        
        guard let viewController = gameViewController else {
            return nil
        }
        
        var lineX: Double = 0
        
        switch side {
        case .left:
            lineX = sideArea.width + roadLane.width - separateLine.width / 2.0
        case .right:
            lineX = sideArea.width + 2 * roadLane.width - separateLine.width / 2.0
        }
        
        let laneSeparator = UIView(frame: CGRect(x: lineX, y: -separateLine.height, width: separateLine.width, height: separateLine.height))
        laneSeparator.backgroundColor = separateLineColor
        laneSeparator.isUserInteractionEnabled = false
        
        viewController.view.addSubview(laneSeparator)
        cachedLaneSeparators[side]?.append(laneSeparator)
        
        return laneSeparator
    }
    
    private func generateTree(side: Side) -> UIImageView? {
        if let createdTree = cachedTrees[side]?.first(where: { imageView in
            return imageView.isHidden
        })
        {
            createdTree.isHidden = false
            return createdTree
        }
        
        guard let sideArea = sideAreaSize else {
            return nil
        }
        
        guard let view = viewSize else {
            return nil
        }
        
        guard let tree = treeSize else {
            return nil
        }
        
        guard let viewController = gameViewController else {
            return nil
        }
        
        var treeX: Double = 0
        
        switch side {
        case .left:
            treeX = (sideArea.width - tree.width) / 2.0
        case .right:
            treeX = view.width - ((sideArea.width + tree.width) / 2.0)
        }
        
        let object = UIImageView(frame: CGRect(x: treeX, y: -tree.height, width: tree.width, height: tree.height))
        object.contentMode = .scaleAspectFit
        object.isUserInteractionEnabled = false
        let objectImage = UIImage(named: "tree")
        object.image = objectImage
        
        viewController.view.addSubview(object)
        cachedTrees[side]?.append(object)
        
        return object
    }
    
    private func generateBush(side: Side) -> UIImageView? {
        if let createdBush = cachedBushes[side]?.first(where: { imageView in
            return imageView.isHidden
        })
        {
            createdBush.isHidden = false
            return createdBush
        }
        
        guard let sideArea = sideAreaSize else {
            return nil
        }
        
        guard let view = viewSize else {
            return nil
        }
        
        guard let bush = bushSize else {
            return nil
        }
        
        guard let viewController = gameViewController else {
            return nil
        }
        
        var bushX: Double = 0
        
        switch side {
        case .left:
            bushX = (sideArea.width - bush.width) / 2.0
        case .right:
            bushX = view.width - ((sideArea.width + bush.width) / 2.0)
        }
        
        let object = UIImageView(frame: CGRect(x: bushX, y: -bush.height, width: bush.width, height: bush.height))
        object.contentMode = .scaleAspectFit
        object.isUserInteractionEnabled = false
        let objectImage = UIImage(named: "bush")
        object.image = objectImage
        
        viewController.view.addSubview(object)
        cachedBushes[side]?.append(object)
        
        return object
    }
    
    private func generateRandomSideItem(side: Side) -> UIImageView? {
        let randomItem = Int.random(in: 0...2)
        
        if (randomItem == 0) {
            return generateBush(side: side)
        } else {
            return generateTree(side: side)
        }
    }

    func generateCivilCar(lane: Lane) -> UIImageView? {
        if let createdCivilCar = cachedCivilCars[lane]?.first(where: { imageView in
            return imageView.isHidden
        })
        {
            createdCivilCar.isHidden = false
            return createdCivilCar
        }
        
        guard let sideArea = sideAreaSize else {
            return nil
        }
        
        guard let roadLane = roadLaneSize else {
            return nil
        }
        
        guard let viewController = gameViewController else {
            return nil
        }
        
        guard let car = carSize else {
            return nil
        }
        
        var carX: Double = 0

        switch lane {
        case .left:
            carX = sideArea.width + (roadLane.width - car.width) / 2.0
        case .middle:
            carX = sideArea.width + roadLane.width + (roadLane.width - car.width) / 2.0
        case .right:
            carX = sideArea.width + 2 * roadLane.width + (roadLane.width - car.width) / 2.0
        }

        let civilCar = UIImageView(frame: CGRect(x: carX, y: -car.height, width: car.width, height: car.height))
        civilCar.transform = CGAffineTransform(rotationAngle: .pi)
        civilCar.contentMode = .scaleAspectFit
        civilCar.isUserInteractionEnabled = false
        let civilCarImage = UIImage(named: "enemy_car")
        civilCar.image = civilCarImage
        civilCar.layer.zPosition = 9
        civilCar.applyShadow(offset: CGSize(width: -4, height: -3), radius: 7)

        viewController.view.addSubview(civilCar)
        cachedCivilCars[lane]?.append(civilCar)

        return civilCar
    }

    func generateTruck(lane: Lane) -> UIImageView? {
        if let createdTruck = cachedTrucks[lane]?.first(where: { imageView in
            return imageView.isHidden
        })
        {
            createdTruck.isHidden = false
            return createdTruck
        }
        
        guard let sideArea = sideAreaSize else {
            return nil
        }
        
        guard let roadLane = roadLaneSize else {
            return nil
        }
        
        guard let viewController = gameViewController else {
            return nil
        }
        
        guard let truck = truckSize else {
            return nil
        }
        
        var truckX: Double = 0

        switch lane {
        case .left:
            truckX = sideArea.width + (roadLane.width - truck.width) / 2.0
        case .middle:
            truckX = sideArea.width + roadLane.width + (roadLane.width - truck.width) / 2.0
        case .right:
            truckX = sideArea.width + 2 * roadLane.width + (roadLane.width - truck.width) / 2.0
        }

        let truckObject = UIImageView(frame: CGRect(x: truckX, y: -truck.height, width: truck.width, height: truck.height))
        truckObject.transform = CGAffineTransform(rotationAngle: .pi)
        truckObject.contentMode = .scaleAspectFit
        truckObject.isUserInteractionEnabled = false
        let truckImage = UIImage(named: "truck")
        truckObject.image = truckImage
        truckObject.layer.zPosition = 9
        truckObject.applyShadow(offset: CGSize(width: -4, height: -3), radius: 10)
        
        viewController.view.addSubview(truckObject)
        cachedTrucks[lane]?.append(truckObject)

        return truckObject
    }

    func generateRandomVehicle() -> UIImageView? {
        var lane = Lane.right
        let randomItem = Int.random(in: 0...2)

        if randomItem == 0 {
            lane = .left
        } else if randomItem == 1 {
            lane = .middle
        }

        let randomVehicle = Int.random(in: 0...2)

        return randomVehicle == 2 ? generateTruck(lane: lane) : generateCivilCar(lane: lane)
    }
    
    private func cofigureObjectSizes(viewSize: CGSize) {
        self.viewSize = viewSize
        
        let sideAreaWidth = viewSize.width * 0.15
        sideAreaSize = CGSize(width: sideAreaWidth, height: viewSize.height)
        
        let roadLaneWidth = (viewSize.width - 2 * sideAreaWidth) / 3
        roadLaneSize = CGSize(width: roadLaneWidth, height: viewSize.height)
        
        let carWidth = roadLaneWidth * 0.4
        let carHeight = carWidth * 29.0 / 18.0
        carSize = CGSize(width: carWidth, height: carHeight)
        
        let truckWidth = roadLaneWidth * 0.5
        let truckHeight = truckWidth * 11.0 / 4.0
        truckSize = CGSize(width: truckWidth, height: truckHeight)
        
        let treeWidth = sideAreaWidth * 0.6
        let treeHeight = treeWidth * 9 / 5
        treeSize = CGSize(width: treeWidth, height: treeHeight)
        
        let bushWidth = sideAreaWidth * 0.4
        let bushHeight = bushWidth * 5 / 6
        bushSize = CGSize(width: bushWidth, height: bushHeight)
        
        let separateLineWidth = carWidth * 0.15
        let separateLineHeight = separateLineWidth * 6
        separateLineSize = CGSize(width: separateLineWidth, height: separateLineHeight)
    }
}
