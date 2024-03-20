//
//  SupplementViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/9/24.
//

import UIKit
import SnapKit

final class SupplementViewController: BaseViewController {
    private let viewModel = MySupplementViewModel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<String, SupplementName>!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = ()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bindData() {
        viewModel.inputViewDidLoad.value = ()
        
        viewModel.outputSetNavigation.bind { [weak self] _ in
            guard let self else { return }
            navigationItem.title = Constants.NavigationTitle.MySupplement.title
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        viewModel.outputSupplementData.bind { [weak self] value in
            guard let self, let value else { return }
            makeCellRegistration()
            updateSnapshot()
        }
        viewModel.outputCheckButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            makeCellRegistration()
            updateSnapshot()
        }
    }
    
    private func makeCellRegistration() {
        let cellRegistration = cellRegistration()
        let headerRegistration = headerRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { view, kind, index in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, SupplementName>()
        snapshot.appendSections(viewModel.outputSection.value)
        
        viewModel.outputSupplementData.value?.forEach {
            snapshot.appendItems($0.value, toSection: $0.key)
        }
        dataSource.apply(snapshot)
    }
}


extension SupplementViewController {
    @objc func plusButtonTapped() {
        let vc = SettingNotificationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func checkButtonTapped(_ sender: CheckButton) {
        guard let section = dataSource.snapshot().sectionIdentifier(containingItem: sender.item) else { return }
        viewModel.inputCheckButtonTapped.value = (section: section, supplement: sender.item.name)
    }
}

// MARK: Layout
extension SupplementViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 20, trailing: 15)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HeaderSupplementaryView.id, alignment: .topLeading)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func cellRegistration() -> UICollectionView.CellRegistration<SupplementCollectionViewCell, SupplementName> {
        return UICollectionView.CellRegistration { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            guard let section = dataSource.snapshot().sectionIdentifier(containingItem: itemIdentifier) else { return }
            cell.configureCell(item: itemIdentifier, index: indexPath, section: section)
            cell.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        }
    }
    
    private func headerRegistration() -> UICollectionView.SupplementaryRegistration<HeaderSupplementaryView> {
        return UICollectionView.SupplementaryRegistration(elementKind: HeaderSupplementaryView.id, handler: { [weak self] supplementaryView, elementKind, indexPath in
            guard let self else { return }
            guard let model = dataSource.itemIdentifier(for: indexPath), let section = dataSource.snapshot().sectionIdentifier(containingItem: model) else { return }
            supplementaryView.label.text = section
        })
    }
}
