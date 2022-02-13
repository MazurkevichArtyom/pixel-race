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
    
    private let sideColor = UIColor(red: 118 / 255.0, green: 172 / 255.0, blue: 31 / 255.0, alpha: 1.0)
    private let laneColor = UIColor(red: 160 / 255.0, green: 160 / 255.0, blue: 160 / 255.0, alpha: 1.0)
    private let sideSeparatorColor = UIColor(red: 120 / 255.0, green: 120 / 255.0, blue: 120 / 255.0, alpha: 1.0)
    private let separateLineColor = UIColor.white
    
    private var viewSize: CGSize?
    private var sideAreaSize: CGSize?
    private var roadLaneSize: CGSize?
    private var carSize: CGSize?
    private var truckSize: CGSize?
    private var treeSize: CGSize?
    private var bushSize: CGSize?
    private var roadSignSize: CGSize?
    private var separateLineSize: CGSize?
    
    private var startYOfSideObjects: CGFloat?
    private var endYOfSideObjects: CGFloat?
    private var startYOfTrafficObjects: CGFloat?
    private var endYOfTrafficObjects: CGFloat?

    private var laneSeparatorsTimer: Timer?
    private var leftSideItemsTimer: Timer?
    private var rightSideItemsTimer: Timer?
    private var trafficFlowTimer: Timer?
    
    private var cachedCivilCars: [Lane: [UIImageView]] = [.left: [UIImageView](), .middle: [UIImageView](), .right: [UIImageView]()]
    private var cachedTrucks: [Lane: [UIImageView]] = [.left: [UIImageView](), .middle: [UIImageView](), .right: [UIImageView]()]
    private var cachedTrees: [Side: [UIImageView]] = [.left: [UIImageView](), .right :[UIImageView]()]
    private var cachedBushes: [Side: [UIImageView]] = [.left: [UIImageView](), .right :[UIImageView]()]
    private var cachedRoadSignes: [Side: [UIImageView]] = [.left: [UIImageView](), .right :[UIImageView]()]
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
        animateGeneratedSideObject(side: .right)
        restartRightSideItemsTimer()
    }
    
    @objc private func generateLeftSideItems() {
        animateGeneratedSideObject(side: .left)
        restartLeftSideItemsTimer()
    }
    
    @objc private func generateEnemysCars() {
        guard let vehicle = generateRandomVehicle() else {
            return
        }
        
        guard let endY = endYOfTrafficObjects else {
            return
        }
        
        let enemysCarInitialCenter = vehicle.center
        
        CollisionManager.shared.addObservableObject(observable: vehicle)
        let duration = vehicle.accessibilityIdentifier == "truck" ? 2.3 : 2.0
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
            vehicle.center = CGPoint(x: vehicle.center.x, y: endY)
        } completion: { finish in
            vehicle.center = enemysCarInitialCenter
            vehicle.isHidden = true
            CollisionManager.shared.removeObservableObject(observable: vehicle)
        }
        
        restartTrafficFlowTimer()
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
    
    private func animateGeneratedSideObject(side: Side) {
        guard let sideObject = generateRandomSideObject(side: side) else {
            return
        }
        
        guard let endY = endYOfSideObjects else {
            return
        }
        
        let sideObjectInitialCenter = sideObject.center
        
        UIView.animate(withDuration: 2.5, delay: 0, options: .curveLinear) {
            sideObject.center = CGPoint(x: sideObject.center.x, y: endY)
        } completion: { finish in
            sideObject.center = sideObjectInitialCenter
            sideObject.isHidden = true
        }
    }
    
    private func generateRandomSideObject(side: Side) -> UIImageView? {
        let randomItem = Int.random(in: 0...5)
        
        if (randomItem == 0 || randomItem == 1) {
            return generateSideObject(object: .bush, side: side)
        } else if (randomItem == 2 || randomItem == 3 || randomItem == 4) {
            return generateSideObject(object: .tree, side: side)
        } else {
            return generateSideObject(object: .roadSign, side: side)
        }
    }
    
    private func generateSideObject(object: SideObject, side: Side) -> UIImageView? {
        if let cachedObject = cachedSideObject(object: object, side: side) {
            return cachedObject
        }
        
        var objectSize: CGSize?
        
        switch object {
        case .tree:
            objectSize = treeSize
        case .bush:
            objectSize = bushSize
        case .roadSign:
            objectSize = roadSignSize
        }
        
        guard let size = objectSize else {
            return nil
        }
        
        guard let sideArea = sideAreaSize else {
            return nil
        }
        
        guard let view = viewSize else {
            return nil
        }
        
        guard let startY = startYOfSideObjects else {
            return nil
        }
        
        guard let viewController = gameViewController else {
            return nil
        }
        
        var objectX: Double = 0
        
        switch side {
        case .left:
            objectX = (sideArea.width - size.width) / 2.0
        case .right:
            objectX = view.width - ((sideArea.width + size.width) / 2.0)
        }
        
        let imageView = UIImageView(frame: CGRect(x: objectX, y: startY, width: size.width, height: size.height))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        let objectImage = UIImage(named: sideObjectImageName(object: object))
        imageView.image = objectImage
        
        viewController.view.addSubview(imageView)
        
        switch object {
        case .tree:
            cachedTrees[side]?.append(imageView)
        case .bush:
            cachedBushes[side]?.append(imageView)
        case .roadSign:
            cachedRoadSignes[side]?.append(imageView)
        }
        
        return imageView
    }
    
    private func generateTrafficObject(object: TrafficObject, lane: Lane) -> UIImageView? {
        if let cachedObject = cachedTrafficObject(object: object, lane: lane) {
            return cachedObject
        }
        
        var objectSize: CGSize?
        
        switch object {
        case .car:
            objectSize = carSize
        case .truck:
            objectSize = truckSize
        }
        
        guard let size = objectSize else {
            return nil
        }
        
        guard let sideArea = sideAreaSize else {
            return nil
        }
        
        guard let roadLane = roadLaneSize else {
            return nil
        }
        
        guard let startY = startYOfTrafficObjects else {
            return nil
        }
        
        guard let viewController = gameViewController else {
            return nil
        }
        
        var objectX: Double = 0

        switch lane {
        case .left:
            objectX = sideArea.width + (roadLane.width - size.width) / 2.0
        case .middle:
            objectX = sideArea.width + roadLane.width + (roadLane.width - size.width) / 2.0
        case .right:
            objectX = sideArea.width + 2 * roadLane.width + (roadLane.width - size.width) / 2.0
        }

        let imageView = UIImageView(frame: CGRect(x: objectX, y: startY, width: size.width, height: size.height))
        imageView.transform = CGAffineTransform(rotationAngle: .pi)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        let objectImage = UIImage(named: trafficObjectImageName(object: object))
        imageView.image = objectImage
        imageView.layer.zPosition = 9
        
        viewController.view.addSubview(imageView)
        
        switch object {
        case .car:
            cachedCivilCars[lane]?.append(imageView)
        case .truck:
            cachedTrucks[lane]?.append(imageView)
        }
        
        return imageView
    }
    
    private func sideObjectImageName(object: SideObject) -> String {
        switch object {
        case .tree:
            return "tree"
        case .bush:
            return "bush"
        case .roadSign:
            return "road_sign_\(Int.random(in: 1...2))"
        }
    }
    
    private func trafficObjectImageName(object: TrafficObject) -> String {
        switch object {
        case .car:
            return "enemy_car"
        case .truck:
            return "truck"
        }
    }
    
    private func cachedSideObject(object: SideObject, side: Side) -> UIImageView? {
        var cachedObjects: [Side: [UIImageView]]
        
        switch object {
        case .tree:
            cachedObjects = cachedTrees
//            print("TREES: L-\(cachedTrees[.left]?.count ?? 0) R-\(cachedTrees[.right]?.count ?? 0)")
        case .bush:
            cachedObjects = cachedBushes
//            print("BUSHES: L-\(cachedBushes[.left]?.count ?? 0) R-\(cachedBushes[.right]?.count ?? 0)")
        case .roadSign:
            cachedObjects = cachedRoadSignes
//            print("RSIGNS: L-\(cachedRoadSignes[.left]?.count ?? 0) R-\(cachedRoadSignes[.right]?.count ?? 0)")
        }
        
        if let cachedObject = cachedObjects[side]?.first(where: { imageView in
            return imageView.isHidden
        })
        {
            cachedObject.isHidden = false
            return cachedObject
        }
        
        return nil
    }
    
    private func cachedTrafficObject(object: TrafficObject, lane: Lane) -> UIImageView? {
        var cachedObjects: [Lane: [UIImageView]]
        
        switch object {
        case .car:
            cachedObjects = cachedCivilCars
//            print("CARS: L-\(cachedCivilCars[.left]?.count ?? 0) M-\(cachedCivilCars[.middle]?.count ?? 0) R-\(cachedCivilCars[.right]?.count ?? 0)")
        case .truck:
            cachedObjects = cachedTrucks
//            print("TRUCKS: L-\(cachedTrucks[.left]?.count ?? 0) M-\(cachedTrucks[.middle]?.count ?? 0) R-\(cachedTrucks[.right]?.count ?? 0)")
        }
        
        if let cachedObject = cachedObjects[lane]?.first(where: { imageView in
            return imageView.isHidden
        })
        {
            cachedObject.isHidden = false
            return cachedObject
        }
        
        return nil
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

        return generateTrafficObject(object: randomVehicle == 2 ? .truck : .car, lane: lane)
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
        
        startYOfTrafficObjects = -max(carHeight, truckHeight)
        endYOfTrafficObjects = viewSize.height + max(carHeight, truckHeight)
        
        let treeWidth = sideAreaWidth * 0.6
        let treeHeight = treeWidth * 9 / 5
        treeSize = CGSize(width: treeWidth, height: treeHeight)
        
        let bushWidth = sideAreaWidth * 0.4
        let bushHeight = bushWidth * 5 / 6
        bushSize = CGSize(width: bushWidth, height: bushHeight)
        
        let roadSignWidth = bushWidth
        let roadSignHeight = roadSignWidth * 23.0 / 12.0
        roadSignSize = CGSize(width: roadSignWidth, height: roadSignHeight)
        
        startYOfSideObjects = -max(treeHeight, bushHeight, roadSignHeight)
        endYOfSideObjects = viewSize.height + max(treeHeight, bushHeight, roadSignHeight)
        
        let separateLineWidth = carWidth * 0.15
        let separateLineHeight = separateLineWidth * 6
        separateLineSize = CGSize(width: separateLineWidth, height: separateLineHeight)
    }
}
