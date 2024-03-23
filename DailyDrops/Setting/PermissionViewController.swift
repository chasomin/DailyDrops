//
//  PermissionViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/23/24.
//

import UIKit
import SnapKit

final class PermissionViewController: BaseViewController {
    private let viewModel = PermissionViewModel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        viewModel.inputViewDidLoad.value = ()
        
        viewModel.outputNotification.bind { [weak self] value in
            guard let self, let value else { return }
            showAlert(title: "알림 설정", message: "알림 권한 설정을 위해 아이폰 설정 앱으로 이동합니다.\n설정 > DailyDrops > 알림") { _ in
                if let setting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(setting)
                } else {
                    print("설정으로 가주세요")
                }
            }
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
        ReloadManager.shared.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PermissionTableViewCell.self, forCellReuseIdentifier: PermissionTableViewCell.id)
    }
    
    @objc func switchTapped(_ sender: UISwitch) {
        viewModel.inputSwitchTapped.value = ()
        guard let value = viewModel.outputSwitchValue.value else { return }
        sender.setOn(value, animated: true)
    }
}

extension PermissionViewController: ReloadProtocol {
    func didBecomeActive() {
        tableView.reloadData()
        viewModel.inputViewDidLoad.value = ()
    }
}

extension PermissionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PermissionTableViewCell.id, for: indexPath) as! PermissionTableViewCell
        cell.permissionSwitch.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
        cell.configureCell(index: indexPath.row)
        return cell
    }
}


