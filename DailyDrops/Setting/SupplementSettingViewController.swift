//
//  SupplementSettingViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/20/24.
//

import UIKit
import SnapKit

final class SupplementSettingViewController: BaseViewController {
    private let viewModel = SupplementSettingViewModel()

    private let tableView = UITableView()
    private let emptyView = EmptyView(image: .mySupplementEmpty, text: Constants.Empty.supplement.rawValue, frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        navigationItem.title = Constants.Setting.supplement.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputSupplementViewDidLoad.value = ()
    }
    
    private func bindData() {
        viewModel.outputSupplement.bind { [weak self] value in
            guard let self, let value else { return }
            tableView.reloadData()
            if value.isEmpty {
                tableView.isHidden = true
            } else {
                tableView.isHidden = false
            }

        }
    }
    
    override func configureHierarchy() {
        view.addSubview(emptyView)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

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
        viewModel.outputSupplement.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SupplementSettingTableViewCell.id, for: indexPath) as! SupplementSettingTableViewCell
        guard let supplement = viewModel.outputSupplement.value else { return UITableViewCell() }
        cell.configureCell(data: supplement[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { [weak self] _, _, _ in
            guard let self else { return }
            viewModel.inputSupplementDeleteAction.value = viewModel.outputSupplement.value?[indexPath.row]
        }
        delete.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions:[delete])
    }
}
