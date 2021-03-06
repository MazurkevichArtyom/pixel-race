//
//  SpawnerManger.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 11.02.2022.
//

import Foundation
import UIKit

class SpawnerManager {
    var playersCar: UIImageView?
    
    private var trafficCount = 0
    private var settings = Settings()
    private var startGameDate: Date?
    lazy private var dateFormatter = DateFormatter()
    
    private let collisionManager: CollisionManager
    private let gameViewController: UIViewController
    
    private let staticObjectDuration = 2.5
    
    var viewSize: CGSize?
    var sideAreaSize: CGSize?
    var roadLaneSize: CGSize?
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
    
    // need to move in GameManager
    private var laneSeparatorsTimer: Timer?
    private var leftSideItemsTimer: Timer?
    private var rightSideItemsTimer: Timer?
    private var trafficFlowTimer: Timer?
    private var middleRoadEffectsTimer: Timer?
    private var leftRoadEffectsTimer: Timer?
    private var rightRoadEffectsTimer: Timer?
    private var leftSideEffectsTimer: Timer?
    private var rightSideEffectsTimer: Timer?
    
    private var cachedCivilCars: [Lane: [UIImageView]] = [.left: [UIImageView](), .middle: [UIImageView](), .right: [UIImageView]()]
    private var cachedTrucks: [Lane: [UIImageView]] = [.left: [UIImageView](), .middle: [UIImageView](), .right: [UIImageView]()]
    private var cachedRoadEffects: [Lane: [UIView]] = [.left: [UIView](), .middle: [UIView](), .right: [UIView]()]
    private var cachedSideEffects: [Side: [UIView]] = [.left: [UIView](), .right :[UIView]()]
    private var cachedTrees: [Side: [UIImageView]] = [.left: [UIImageView](), .right :[UIImageView]()]
    private var cachedBushes: [Side: [UIImageView]] = [.left: [UIImageView](), .right :[UIImageView]()]
    private var cachedRoadSignes: [Side: [UIImageView]] = [.left: [UIImageView](), .right :[UIImageView]()]
    private var cachedLaneSeparators: [Side: [UIView]] = [.left: [UIView](), .right :[UIView]()]
    
    init(collisionManager: CollisionManager, viewController: UIViewController) {
        self.collisionManager = collisionManager
        self.gameViewController = viewController
        self.cofigureObjectSizes(viewSize: gameViewController.view.frame.size)
        dateFormatter.dateFormat = "MM/dd\nyyyy"
        tryToGetSettings()
    }
    
    func setupRacingLocation() {
        setupSide(side: .left)
        setupSide(side: .right)
        
        setupLane(type: .left)
        setupLane(type: .middle)
        setupLane(type: .right)
        
        setupSideSeparator(side: .left)
        setupSideSeparator(side: .right)
        
        setupPlyersCar()
    }
    
    func startGameObjectSpawning() {
        startGameDate = Date()
        
        startLaneSeparatorsSpawning()
        startSideObjectsSpawning()
        startTrafficFlowSpawning()
        startRoadEffectsSpawning()
        startSideEffectsSpawning()
    }
    
    func invalidate() {
        laneSeparatorsTimer?.invalidate()
        leftSideItemsTimer?.invalidate()
        rightSideItemsTimer?.invalidate()
        trafficFlowTimer?.invalidate()
        middleRoadEffectsTimer?.invalidate()
        leftRoadEffectsTimer?.invalidate()
        rightRoadEffectsTimer?.invalidate()
        leftSideEffectsTimer?.invalidate()
        rightSideEffectsTimer?.invalidate()
        
        gameViewController.view.layer.removeAllAnimations()
        
        clearAllCachedData()
    }
    
    func gameResult() -> Result? {
        if let startDate = startGameDate {
            return Result(difficulty: settings.difficulty, playersCarSkinId: settings.skinId, trafficCount: trafficCount, date: dateFormatter.string(from: Date()), timeDuration: abs(startDate.timeIntervalSinceNow))
        } else {
            return nil
        }
    }
    
    private func tryToGetSettings() {
        if let savedData = UserDefaults.standard.value(forKey: Resources.UserDefaultsKeys.settings) as? Data {
            if let savedSettings = try? JSONDecoder().decode(Settings.self, from: savedData) {
                settings = savedSettings
            }
        }
    }
    
    private func startLaneSeparatorsSpawning() {
        restartLaneSeparatorsTimer()
    }
    
    private func startSideObjectsSpawning() {
        restartLeftSideItemsTimer()
        restartRightSideItemsTimer()
    }
    
    private func startTrafficFlowSpawning() {
        restartTrafficFlowTimer()
    }
    
    private func startRoadEffectsSpawning() {
        restartMiddleRoadEffectsTimer();
        restartLeftRoadEffectsTimer();
        restartRightRoadEffectsTimer();
    }
    
    private func startSideEffectsSpawning() {
        restartLeftSideEffectsTimer()
        restartRightSideEffectsTimer()
    }
    
    private func restartLaneSeparatorsTimer() {
        laneSeparatorsTimer?.invalidate()
        laneSeparatorsTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(animateLaneSeparators), userInfo: nil, repeats: true)
    }
    
    private func restartLeftSideItemsTimer() {
        leftSideItemsTimer?.invalidate()
        leftSideItemsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.3...1.0), target: self, selector: #selector(animateLeftSideItems), userInfo: nil, repeats: false)
    }
    
    private func restartRightSideItemsTimer() {
        rightSideItemsTimer?.invalidate()
        rightSideItemsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.3...1.0), target: self, selector: #selector(animateRightSideItems), userInfo: nil, repeats: false)
    }
    
    private func restartTrafficFlowTimer() {
        trafficFlowTimer?.invalidate()
        trafficFlowTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.5...1.0) * difficultyCoefficient(), target: self, selector: #selector(animateTrafficObjects), userInfo: nil, repeats: false)
    }
    
    private func restartMiddleRoadEffectsTimer() {
        middleRoadEffectsTimer?.invalidate()
        middleRoadEffectsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.1...0.4), target: self, selector: #selector(animateMiddleRoadEffects), userInfo: nil, repeats: false)
    }
    
    private func restartLeftRoadEffectsTimer() {
        leftRoadEffectsTimer?.invalidate()
        leftRoadEffectsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.1...0.4), target: self, selector: #selector(animateLeftRoadEffects), userInfo: nil, repeats: false)
    }
    
    private func restartRightRoadEffectsTimer() {
        rightRoadEffectsTimer?.invalidate()
        rightRoadEffectsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.1...0.4), target: self, selector: #selector(animateRightRoadEffects), userInfo: nil, repeats: false)
    }
    
    private func restartLeftSideEffectsTimer() {
        leftSideEffectsTimer?.invalidate()
        leftSideEffectsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.1...0.4), target: self, selector: #selector(animateLeftSideEffects), userInfo: nil, repeats: false)
    }
    
    private func restartRightSideEffectsTimer() {
        rightSideEffectsTimer?.invalidate()
        rightSideEffectsTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.1...0.4), target: self, selector: #selector(animateRightSideEffects), userInfo: nil, repeats: false)
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
        
        for item in cachedRoadEffects {
            for objects in item.value {
                objects.removeFromSuperview()
            }
        }
        
        cachedRoadEffects = [.left: [UIView](), .middle: [UIView](), .right: [UIView]()]
        
        for item in cachedSideEffects {
            for objects in item.value {
                objects.removeFromSuperview()
            }
        }
        
        cachedSideEffects = [.left: [UIView](), .right :[UIView]()]
    }
    
    @objc private func animateLaneSeparators() {
        
        guard let leftLaneSeparator = generateLaneSeparator(side: .left),
              let rightLaneSeparator = generateLaneSeparator(side: .right),
              let endY = endYOfSideObjects else {
            return
        }
        
        let leftLaneInitialCenter = leftLaneSeparator.center
        let rightLaneInitialCenter = rightLaneSeparator.center
        
        UIView.animate(withDuration: staticObjectDuration, delay: 0, options: .curveLinear) {
            leftLaneSeparator.center = CGPoint(x: leftLaneSeparator.center.x , y: endY)
            rightLaneSeparator.center = CGPoint(x: rightLaneSeparator.center.x , y: endY)
        } completion: { finish in
            leftLaneSeparator.center = leftLaneInitialCenter
            rightLaneSeparator.center = rightLaneInitialCenter
            leftLaneSeparator.isHidden = true
            rightLaneSeparator.isHidden = true
        }
    }
    
    @objc private func animateRightSideItems() {
        animateGeneratedSideObject(side: .right)
        restartRightSideItemsTimer()
    }
    
    @objc private func animateLeftSideItems() {
        animateGeneratedSideObject(side: .left)
        restartLeftSideItemsTimer()
    }
    
    @objc private func animateTrafficObjects() {
        guard let vehicle = generateRandomTrafficObject(),
              let endY = endYOfTrafficObjects else {
            return
        }
        
        let enemysCarInitialCenter = vehicle.center
        
        collisionManager.addObservableObject(observable: vehicle)
        let duration = (vehicle.accessibilityIdentifier == "truck" ? 2.3 : 2.0) * difficultyCoefficient()
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
            vehicle.center = CGPoint(x: vehicle.center.x, y: endY)
        } completion: { finish in
            vehicle.center = enemysCarInitialCenter
            vehicle.isHidden = true
            self.trafficCount += 1
            self.collisionManager.removeObservableObject(observable: vehicle)
        }
        
        restartTrafficFlowTimer()
    }
    
    @objc private func animateMiddleRoadEffects() {
        animateRoadEffect(lane: .middle)
        restartMiddleRoadEffectsTimer()
    }
    
    @objc private func animateLeftRoadEffects() {
        animateRoadEffect(lane: .left)
        restartLeftRoadEffectsTimer()
    }
    
    @objc private func animateRightRoadEffects() {
        animateRoadEffect(lane: .right)
        restartRightRoadEffectsTimer()
    }
    
    @objc private func animateLeftSideEffects() {
        animateSideEffect(side: .left)
        restartLeftSideEffectsTimer()
    }
    
    @objc private func animateRightSideEffects() {
        animateSideEffect(side: .right)
        restartRightSideEffectsTimer()
    }
    
    func generateRandomTrafficObject() -> UIImageView? {
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
    
    private func difficultyCoefficient() -> Double {
        switch settings.difficulty {
        case .easy:
            return 1.0
        case .normal:
            return 0.8
        case .hard:
            return 0.6
        }
    }
    
    private func setupSide(side: Side) {
        guard let sideArea = sideAreaSize,
              let view = viewSize else {
            return
        }
        
        let side = UIView(frame: CGRect(x: side == .left ? 0 : view.width - sideArea.width, y: 0, width: sideArea.width, height: sideArea.height))
        side.backgroundColor = Resources.Colors.sideColor
        side.isUserInteractionEnabled = false
        
        gameViewController.view.addSubview(side)
    }
    
    private func setupLane(type: Lane) {
        guard let roadLane = roadLaneSize,
              let sideArea = sideAreaSize else {
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
        lane.backgroundColor = Resources.Colors.laneColor
        lane.isUserInteractionEnabled = false
        
        gameViewController.view.addSubview(lane)
    }
    
    private func setupSideSeparator(side: Side) {
        guard let sideArea = sideAreaSize,
              let roadLane = roadLaneSize,
              let separateLine = separateLineSize,
              let view = viewSize else {
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
        line.backgroundColor = Resources.Colors.sideSeparatorColor
        line.isUserInteractionEnabled = false
        
        gameViewController.view.addSubview(line)
    }
    
    private func setupPlyersCar() {
        guard let sideArea = sideAreaSize,
              let roadLane = roadLaneSize,
              let view = viewSize,
              let car = carSize else {
            return
        }
        
        let myCar = UIImageView(frame: CGRect(x: sideArea.width + roadLane.width + (roadLane.width - car.width) / 2.0 , y: view.height - view.height * 0.05 - car.height, width: car.width, height: car.height))
        myCar.contentMode = .scaleAspectFit
        myCar.isUserInteractionEnabled = false
        let image = UIImage(named: ResourcesHelper.playersCarSkin(skinId: settings.skinId))
        myCar.image = image
        myCar.layer.zPosition = 10
        myCar.applyShadow(offset: CGSize(width: 5, height: 4), radius: 3)
        
        playersCar = myCar
        
        gameViewController.view.addSubview(myCar)
    }
    
    private func generateLaneSeparator(side: Side) -> UIView? {
        if let createdSeparator = cachedLaneSeparators[side]?.first(where: { view in
            return view.isHidden
        })
        {
            createdSeparator.isHidden = false
            return createdSeparator
        }
        
        guard let sideArea = sideAreaSize,
              let roadLane = roadLaneSize,
              let separateLine = separateLineSize,
              let startY = startYOfSideObjects else {
            return nil
        }
        
        var lineX: Double = 0
        
        switch side {
        case .left:
            lineX = sideArea.width + roadLane.width - separateLine.width / 2.0
        case .right:
            lineX = sideArea.width + 2 * roadLane.width - separateLine.width / 2.0
        }
        
        let laneSeparator = UIView(frame: CGRect(x: lineX, y: startY, width: separateLine.width, height: separateLine.height))
        laneSeparator.backgroundColor = Resources.Colors.separateLineColor
        laneSeparator.isUserInteractionEnabled = false
        
        gameViewController.view.addSubview(laneSeparator)
        cachedLaneSeparators[side]?.append(laneSeparator)
        
        return laneSeparator
    }
    
    private func animateGeneratedSideObject(side: Side) {
        guard let sideObject = generateRandomSideObject(side: side),
              let endY = endYOfSideObjects else {
            return
        }
        
        let sideObjectInitialCenter = sideObject.center
        
        UIView.animate(withDuration: staticObjectDuration, delay: 0, options: .curveLinear) {
            sideObject.center = CGPoint(x: sideObject.center.x, y: endY)
        } completion: { finish in
            sideObject.center = sideObjectInitialCenter
            sideObject.isHidden = true
        }
    }
    
    private func animateRoadEffect(lane: Lane) {
        guard let roadEffect = generateRoadEffect(lane: lane),
              let endY = endYOfSideObjects else {
            return
        }
        
        let roadEffectInitialCenter = roadEffect.center
        
        UIView.animate(withDuration: staticObjectDuration, delay: 0, options: .curveLinear) {
            roadEffect.center = CGPoint(x: roadEffect.center.x , y: endY)
        } completion: { finish in
            roadEffect.center = roadEffectInitialCenter
            roadEffect.isHidden = true
        }
    }
    
    private func animateSideEffect(side: Side) {
        guard let sideEffect = generateSideEffect(side: side),
              let endY = endYOfSideObjects else {
            return
        }
        
        let sideEffectInitialCenter = sideEffect.center
        
        UIView.animate(withDuration: staticObjectDuration, delay: 0, options: .curveLinear) {
            sideEffect.center = CGPoint(x: sideEffect.center.x , y: endY)
        } completion: { finish in
            sideEffect.center = sideEffectInitialCenter
            sideEffect.isHidden = true
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
        
        guard let size = objectSize,
              let sideArea = sideAreaSize,
              let view = viewSize,
              let startY = startYOfSideObjects else {
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
        let objectImage = UIImage(named: ResourcesHelper.sideObjectImageName(object: object))
        imageView.image = objectImage
        
        gameViewController.view.addSubview(imageView)
        
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
        
        guard let size = objectSize,
              let sideArea = sideAreaSize,
              let roadLane = roadLaneSize,
              let startY = startYOfTrafficObjects else {
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
        let objectImage = UIImage(named: ResourcesHelper.trafficObjectImageName(object: object))
        imageView.image = objectImage
        imageView.layer.zPosition = 9
        imageView.applyShadow(offset: CGSize(width: -5, height: -4), radius: object == .truck ? 5 : 3)
        
        gameViewController.view.addSubview(imageView)
        
        switch object {
        case .car:
            cachedCivilCars[lane]?.append(imageView)
        case .truck:
            imageView.accessibilityIdentifier = "truck"
            cachedTrucks[lane]?.append(imageView)
        }
        
        return imageView
    }
    
    private func generateRoadEffect(lane: Lane) -> UIView? {
        guard let sideArea = sideAreaSize,
              let roadLane = roadLaneSize,
              let separateLine = separateLineSize,
              let startY = startYOfSideObjects else {
            return nil
        }
        
        var effectX: Double = 0
        
        switch lane {
        case .left:
            effectX = Double.random(in: (sideArea.width + separateLine.width / 2.0)...(sideArea.width + roadLane.width - separateLine.width / 2.0))
        case .middle:
            effectX = Double.random(in: (sideArea.width + roadLane.width + separateLine.width / 2.0)...(sideArea.width + 2 * roadLane.width - separateLine.width / 2.0))
        case .right:
            effectX = Double.random(in: (sideArea.width + 2 * roadLane.width + separateLine.width / 2.0)...(sideArea.width + 3 * roadLane.width - separateLine.width / 2.0 - 6))
        }
        
        let effectBackground = Int.random(in: 0...9) % 2 == 0 ? Resources.Colors.roadEffectColor2 : Resources.Colors.roadEffectColor1
        
        if let createdEffect = cachedRoadEffects[lane]?.first(where: { view in
            return view.isHidden
        })
        {
            createdEffect.frame.origin.x = effectX
            createdEffect.backgroundColor = effectBackground
            createdEffect.isHidden = false
            return createdEffect
        }
        
        let roadEffect = UIView(frame: CGRect(x: effectX, y: startY, width: 6, height: 6))
        roadEffect.backgroundColor = effectBackground
        roadEffect.isUserInteractionEnabled = false
        
        gameViewController.view.addSubview(roadEffect)
        cachedRoadEffects[lane]?.append(roadEffect)
        
        return roadEffect
    }
    
    private func generateSideEffect(side: Side) -> UIView? {
        guard let sideArea = sideAreaSize,
              let view = viewSize,
              let separateLine = separateLineSize,
              let startY = startYOfSideObjects else {
            return nil
        }
        
        var effectX: Double = 0
        
        switch side {
        case .left:
            effectX = Double.random(in: 0...(sideArea.width - separateLine.width / 2.0 - 6))
        case .right:
            effectX = Double.random(in: (view.width - sideArea.width + separateLine.width / 2.0)...(view.width - 6))
        }
        
        let effectBackground = Int.random(in: 0...9) % 2 == 0 ? Resources.Colors.sideEffectColor2 : Resources.Colors.sideEffectColor1
        
        if let createdEffect = cachedSideEffects[side]?.first(where: { view in
            return view.isHidden
        })
        {
            createdEffect.frame.origin.x = effectX
            createdEffect.backgroundColor = effectBackground
            createdEffect.isHidden = false
            return createdEffect
        }
        
        let sideEffect = UIView(frame: CGRect(x: effectX, y: startY, width: 6, height: 6))
        sideEffect.backgroundColor = effectBackground
        sideEffect.isUserInteractionEnabled = false
        
        gameViewController.view.addSubview(sideEffect)
        cachedSideEffects[side]?.append(sideEffect)
        
        return sideEffect
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
        
        let separateLineWidth = carWidth * 0.15
        let separateLineHeight = separateLineWidth * 6
        separateLineSize = CGSize(width: separateLineWidth, height: separateLineHeight)
        
        startYOfSideObjects = -max(treeHeight, bushHeight, roadSignHeight, separateLineHeight)
        endYOfSideObjects = viewSize.height + max(treeHeight, bushHeight, roadSignHeight, separateLineHeight)
    }
}
