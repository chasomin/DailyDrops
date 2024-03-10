//
//  SearchViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/10/24.
//

import UIKit
import SnapKit

class SearchViewController: BaseViewController {
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let viewModel = SupplementViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "영양제 검색"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        tableView.rowHeight = 80
        
        viewModel.inputViewDidLoad.value = ()
        viewModel.outputData.bind { [weak self] data in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        searchBar.placeholder = "영양제 이름을 검색해보세요!"
        searchBar.searchTextField.font = .body
        searchBar.searchBarStyle = .minimal
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as! SearchTableViewCell
        cell.configureCell(data: viewModel.outputData.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label: UILabel = {
            let label = UILabel()
            label.text = "*출처: 식품의약품안전처"
            label.font = .caption
            label.textColor = .subTitleColor
            label.backgroundColor = .backgroundColor
            label.textAlignment = .right
            return label
        }()
        return label
    }
}


