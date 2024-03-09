//
//  SupplementViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/9/24.
//

import UIKit
import SnapKit

final class SupplementViewController: BaseViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "내 영양제 관리"
        
        makeCellRegistration()
        updateSnapshot()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
    
    private func createLayout() -> UICollectionViewLayout{
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .backgroundColor
        configuration.showsSeparators = true
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func makeCellRegistration() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, String> { cell, indexPath, itemIdentifier in // cell 과 cell 데이터 수정
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .backgroundColor
            cell.backgroundConfiguration = background
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["오전 8시","오전 9시","오후 1시"])
        snapshot.appendItems(["유산균"], toSection: "오전 8시")
        snapshot.appendItems(["오메가 3", "루테인"], toSection: "오전 9시")
        snapshot.appendItems(["종합 비타민"], toSection: "오후 1시")
        dataSource.apply(snapshot)
    }
    private func configureHeader(_ headerView: UICollectionViewListCell, at indexPath: IndexPath) {
        guard
            let model = dataSource.itemIdentifier(for: indexPath),
            let section = dataSource.snapshot().sectionIdentifier(containingItem: model) else { return }
        let count = dataSource.snapshot().itemIdentifiers(inSection: section).count
        var content = headerView.defaultContentConfiguration()
        content.text = section
        headerView.contentConfiguration = content
    }
}

// TODO: Header
