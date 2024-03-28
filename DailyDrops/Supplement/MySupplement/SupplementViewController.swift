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
    private let emptyView = EmptyView(image: .mySupplementEmpty, text: Constants.Empty.todaySupplement.rawValue, frame: .zero)
    let date: Date
    
    init(date: Date) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = date
    }
    
    override func configureHierarchy() {
        view.addSubview(emptyView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bindData() {
        viewModel.inputViewDidLoad.value = ()
        
        viewModel.outputSetNavigation.bind { [weak self] _ in
            guard let self else { return }
            navigationItem.title = Constants.NavigationTitle.MySupplement.title
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
        viewModel.outputEmpty.bind { [weak self] value in
            guard let self, let value else { return }
            collectionView.isHidden = value
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
    @objc func checkButtonTapped(_ sender: CheckButton) {
        guard let section = dataSource.snapshot().sectionIdentifier(containingItem: sender.item) else { return }
        viewModel.inputCheckButtonTapped.value = (section: section, supplement: sender.item)
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
            guard let date = viewModel.inputViewWillAppear.value else { return }
            cell.configureCell(item: itemIdentifier, index: indexPath, section: section, isToday: viewModel.outputCheckButtonEnabled.value, date: date)
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
