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
    let viewModel = SearchViewModel()
    var delegate: TransitionValue?
    var searchText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
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
        searchBar.text = searchText
    }
}

extension SearchViewController {
    private func bindData() {
        viewModel.inputViewDidLoad.value = searchText
        viewModel.outputSetNavigation.bind { [weak self] _ in
            guard let self else { return }
            navigationItem.title = Constants.NavigationTitle.SearchSupplement.title
        }
        viewModel.outputSetTableView.bind { [weak self] _ in
            guard let self else { return }
            tableView.delegate = self
            tableView.dataSource = self
            tableView.prefetchDataSource = self
            tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
            tableView.rowHeight = 80
        }
        viewModel.outputSetNavigation.bind { [weak self] _ in
            guard let self else { return }
            searchBar.delegate = self
        }
        viewModel.outputData.bind { [weak self] data in
            guard let self else { return }
            tableView.reloadData()
            view.endEditing(true)
        }
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
        TableViewFooterTextView(frame: .zero, text: "*출처: 식품의약품안전처")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.outputData.value[indexPath.row]
        showAlert(title: data.supplementName, message: data.intakeMethod + "\n\n이 영양제 섭취 알림을 설정할까요?") { [weak self] _ in
            guard let self else { return }
            delegate?.transition(value: data.supplementName)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModel.inputPagenation.value = indexPath
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.inputSearchButtonTapped.value = text
    }
}
