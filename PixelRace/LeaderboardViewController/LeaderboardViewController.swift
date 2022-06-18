//
//  LeaderboardViewController.swift
//  PixelRace
//
//  Created by Artem Mazurkevich on 31.05.2022.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    private let reuseIdentifier = "leaderboard_cell"
    private var results = [Result]()
    private var customNavigationBar: CustomNavigationBar?
    private let tableView = UITableView()
    
    override func loadView() {
        let customView = UIView(frame: UIScreen.main.bounds)
        customView.backgroundColor = Resources.Colors.mainBackgroundColor
        view = customView
        setupNavigationBar()
        setupResultsTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedResults = ResultsManager.savedResults() {
            results = savedResults.sorted(by: {$0.trafficCount > $1.trafficCount})
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationBar() {
        let leftItem = CustomNavigationBarItem(imageName: "button_back", itemAction: {
            self.navigationController?.popViewController(animated: false)
        })
        let rightItem = CustomNavigationBarItem(imageName: "button_reset", itemAction: tryToResetSavedResults)
        let bar = CustomNavigationBar(leftItem: leftItem, rightItem: rightItem)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setTitle(title: "LEADERBOARD")
        view.addSubview(bar)
        
        bar.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bar.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        customNavigationBar = bar
    }
    
    private func setupResultsTableView() {
        guard let customNavigationBar = customNavigationBar else {
            return
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = Resources.Colors.separatorColor
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorInsetReference = .fromCellEdges
        tableView.allowsSelection = false
        tableView.sectionHeaderHeight = 72
        tableView.rowHeight = 72
        tableView.backgroundColor = .clear
        tableView.register(LeaderboardTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func headerView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = Resources.Colors.mainBackgroundColor
        
        let placeLabel = UILabel()
        placeLabel.text = "#"
        placeLabel.font = UIFont(name: "PublicPixel", size: 14)
        placeLabel.textColor = Resources.Colors.secondaryTextColor
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.textAlignment = .left
        headerView.addSubview(placeLabel)
        placeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 32).isActive = true
        placeLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        placeLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.1).isActive = true
        placeLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        
        let carLabel = UILabel()
        carLabel.text = "CAR"
        carLabel.font = UIFont(name: "PublicPixel", size: 14)
        carLabel.textColor = Resources.Colors.secondaryTextColor
        carLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(carLabel)
        carLabel.textAlignment = .center
        carLabel.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor).isActive = true
        carLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        carLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.2).isActive = true
        carLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        
        let dateLabel = UILabel()
        dateLabel.text = "DATE"
        dateLabel.font = UIFont(name: "PublicPixel", size: 14)
        dateLabel.textColor = Resources.Colors.secondaryTextColor
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(dateLabel)
        dateLabel.textAlignment = .center
        dateLabel.leadingAnchor.constraint(equalTo: carLabel.trailingAnchor, constant: 8).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.3).isActive = true
        dateLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        
        let scoreLabel = UILabel()
        scoreLabel.text = "SCORE"
        scoreLabel.font = UIFont(name: "PublicPixel", size: 14)
        scoreLabel.textColor = Resources.Colors.secondaryTextColor
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(scoreLabel)
        scoreLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8).isActive = true
        scoreLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -32).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        
        return headerView
    }
    
    private func tryToResetSavedResults() {
        ResultsManager.clearResults()
        results = [Result]()
        tableView.reloadData()
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

extension LeaderboardViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LeaderboardTableViewCell
        let resultModel = results[indexPath.row]
        cell.placeLabel.text = "\(indexPath.row + 1)."
        cell.scoreLabel.text = String(resultModel.trafficCount)
        cell.dateLabel.text = resultModel.date
        cell.carImageView.image = UIImage(named: ResourcesHelper.playersCarSkin(skinId: resultModel.playersCarSkinId))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView()
    }
}
