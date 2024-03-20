//
//  SupplementSettingViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/20/24.
//

import UIKit
import SnapKit

class SupplementSettingViewController: BaseViewController {
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        navigationItem.title = "영양제 관리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SettingViewModel.shared.inputSupplementViewDidLoad.value = ()
    }
    
    private func bindData() {
        SettingViewModel.shared.outputSupplement.bind { [weak self] value in
            guard let self, let value else { return }
            tableView.reloadData()
        }
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
        tableView.register(SupplementSettingTableViewCell.self, forCellReuseIdentifier: SupplementSettingTableViewCell.id)
    }
    
    @objc func plusButtonTapped() {
        let vc = SettingNotificationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension SupplementSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingViewModel.shared.outputSupplement.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SupplementSettingTableViewCell.id, for: indexPath) as! SupplementSettingTableViewCell
        guard let supplement = SettingViewModel.shared.outputSupplement.value else { return UITableViewCell() }
        cell.configureCell(data: supplement[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { _, _, _ in
            SettingViewModel.shared.inputSupplementDeleteAction.value = SettingViewModel.shared.outputSupplement.value?[indexPath.row]
        }
        delete.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions:[delete])
    }
}
