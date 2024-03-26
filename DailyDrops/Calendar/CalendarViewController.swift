//
//  CalendarViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/18/24.
//

import UIKit
import FSCalendar

final class CalendarViewController: BaseViewController {
    private let viewModel = CalendarViewModel()
    private let calendar = FSCalendar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Constants.Topic, String>!
    private let gesture = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeCellRegistration()
        updateSnapshot()

        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = calendar.selectedDate
    }
    
    private func bindData() {
        viewModel.inputViewDidLoad.value = ()
        
        viewModel.outputViewDidLoad.bind { [weak self] value in
            guard let self, let value else { return }
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingButtonTapped))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: .DD, style: .plain, target: self, action: #selector(logoButtonTapped))
            collectionView.delegate = self
        //FIXME: 로고?
        }
        
        viewModel.outputSetCalendar.bind { [weak self] value in
            guard let self, let value else { return }
            calendar.delegate = self
            calendar.dataSource = self
            calendar.currentPage = Date()
            calendar.select(Date())
            calendar.register(FSCalendarCell.self, forCellReuseIdentifier: FSCalendarCell.id)
        }
        
        viewModel.outputReload.bind { [weak self] value in
            guard let self else { return }
            if value == 3 {
                DispatchQueue.main.async {
                    self.updateSnapshot()
                }
                viewModel.outputReload.value = 0
            }
        }
        
        viewModel.outputNoData.bind { [weak self] value in
            guard let self, let value else { return }
            showToast(value, position: .center)
            calendar.select(Date())
        }
        
        viewModel.outputNotToday.bind { [weak self] value in
            guard let self, let value else { return }
            switch value {
            case true:
                calendar.appearance.titleSelectionColor = .backgroundColor
            case false:
                calendar.appearance.titleSelectionColor = .titleColor
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(calendar)
        view.addSubview(collectionView)
        view.addGestureRecognizer(gesture)
    }
    
    override func configureLayout() {
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendar.collectionView.snp.bottom)//.offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)//.inset(15)
        }
    }
    
    override func configureView() {
        setCalendar()
        collectionView.showsVerticalScrollIndicator = false
//        collectionView.bounces = false
    }
    
    private func makeCellRegistration() {
        let waterCellRegistration = waterCellRegistration()
        let supplementCellRegistration = supplementCellRegistration()
        let stepCellRegistration = stepCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if let section = Constants.Topic(rawValue: indexPath.section) {
                switch section {
                case .water:
                    let cell = collectionView.dequeueConfiguredReusableCell(using: waterCellRegistration, for: indexPath, item: itemIdentifier)
                    print(indexPath.section)
                    return cell
                case .supplement:
                    let cell = collectionView.dequeueConfiguredReusableCell(using: supplementCellRegistration, for: indexPath, item: itemIdentifier)
                    print(indexPath.section)

                    return cell
                case .step:
                    let cell = collectionView.dequeueConfiguredReusableCell(using: stepCellRegistration, for: indexPath, item: itemIdentifier)
                    print(indexPath.section)

                    return cell
                }
            } else {
                return nil
            }
        })
    }

    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Constants.Topic, String>()
        snapshot.appendSections(Constants.Topic.allCases)
        snapshot.appendItems(["1"], toSection: .water)
        snapshot.appendItems(["2"], toSection: .step)
        snapshot.appendItems(["3"], toSection: .supplement)

        dataSource.applySnapshotUsingReloadData(snapshot)
    }

}

extension CalendarViewController {
    
    func setCalendar() {
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scope = .week
        calendar.backgroundColor = .backgroundColor
        calendar.appearance.headerTitleColor = .titleColor
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerTitleFont = .boldTitle
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.weekdayTextColor = .titleColor
        calendar.appearance.weekdayFont = .body
        calendar.appearance.titleFont = .title
        calendar.appearance.titleSelectionColor = .backgroundColor
        calendar.appearance.selectionColor = .secondaryColor
        
        calendar.appearance.titleTodayColor = .pointColor
        calendar.appearance.todaySelectionColor = .pointColor
        calendar.appearance.todayColor = .clear
        calendar.scrollDirection = .horizontal
        calendar.handleScopeGesture(gesture)//TODO: gesture 달/주, 선택 안되는 날짜 회색처리
    }
    
    @objc func settingButtonTapped() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    //FIXME: --- 로고 누르면 오늘날짜로 가는게 말이 됨?., 근데 leftbarbutton 클릭 반짝이는거 못없애,.,,
    @objc func logoButtonTapped() {
        calendar.select(Date())
        viewModel.inputSelectDate.value = Date()
        let topOffset = CGPoint(x: 0, y: -collectionView.contentInset.top)
        collectionView.setContentOffset(topOffset, animated: true)
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let date = calendar.selectedDate else { return }
        switch indexPath.section {
        case 0:
            let vc = WaterViewController(date: date)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = SupplementViewController(date: date)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = StepViewController(date: date)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.inputSelectDate.value = date
    }
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        return date <= Date()
//    }
}

// MARK: - Layout
extension CalendarViewController {
    
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let section = Constants.Topic(rawValue: sectionIndex) else { return nil }
            let layoutSection: NSCollectionLayoutSection
            
            switch section {
            case .water:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                layoutSection = NSCollectionLayoutSection(group: group)
                return layoutSection
                
            case .supplement:
                var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                config.backgroundColor = .backgroundColor
                config.showsSeparators = false
                let layoutSection =  NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
                return layoutSection

            case .step:
                var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                config.backgroundColor = .backgroundColor
                config.showsSeparators = false
                let layoutSection =  NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
                layoutSection.contentInsets.top = 0
                return layoutSection
            }
        }
        return layout
    }

    private func waterCellRegistration() -> UICollectionView.CellRegistration<WaterCollectionViewCell, String> {
        UICollectionView.CellRegistration { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            cell.configureCell(value: viewModel.outputAmountOfDrinksWater.value, selectedDate: calendar.selectedDate)
        }
    }
    
    private func supplementCellRegistration() -> UICollectionView.CellRegistration<SupplementLogCollectionViewCell, String> {
        UICollectionView.CellRegistration { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            cell.configureCell(text: viewModel.outputLeftSupplementCount.value, value: viewModel.outputSupplementProgress.value, selectedDate: calendar.selectedDate)
        }
    }
    
    private func stepCellRegistration() -> UICollectionView.CellRegistration<StepCollectionViewCell, String> {
        UICollectionView.CellRegistration { [weak self] cell, indexPath, itemIdentifier in
            guard let self else { return }
            cell.configureCell(text: viewModel.outputSteps.value, value: viewModel.outputStepsProgress.value, selectedDate: calendar.selectedDate)
        }
    }
}
