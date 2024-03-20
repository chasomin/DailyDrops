//
//  SettingViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/20/24.
//

import UIKit
import SnapKit

final class SettingViewController: BaseViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "설정"
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "setting")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        var config = UIListContentConfiguration.cell()
        switch indexPath.row {
        case 0:
            config.text = Constants.Setting.waterGoal.rawValue
        case 1:
            config.text = Constants.Setting.stepGoal.rawValue
        case 2:
            config.text = Constants.Setting.supplement.rawValue
        case 3:
            config.text = Constants.Setting.notification.rawValue
        default:
            break
        }
        config.textProperties.font = .body
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = WaterGoalSettingViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = StepGoalSettingViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = SupplementSettingViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = WaterGoalSettingViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

