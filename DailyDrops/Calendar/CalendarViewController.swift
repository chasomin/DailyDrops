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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.inputViewWillAppear.value = calendar.selectedDate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func configureHierarchy() {
        view.addSubview(calendar)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendar.collectionView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
    override func configureView() {
        setCalendar()
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 170)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        return layout
    }
    
    private func bindData() {
        viewModel.inputViewDidLoad.value = ()
        
        viewModel.outputSetCalendar.bind { [weak self] value in
            guard let self, let value else { return }
            calendar.delegate = self
            calendar.dataSource = self
            calendar.currentPage = Date()
            calendar.select(Date())
        }
        
        viewModel.outputSetCollectionView.bind { [weak self] value in
            guard let self, let value else { return }
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(WaterCollectionViewCell.self, forCellWithReuseIdentifier: WaterCollectionViewCell.id)
            collectionView.register(SupplementLogCollectionViewCell.self, forCellWithReuseIdentifier: SupplementLogCollectionViewCell.id)
            collectionView.register(StepCollectionViewCell.self, forCellWithReuseIdentifier: StepCollectionViewCell.id)
        }

        viewModel.outputReload.bind { [weak self] value in
            guard let self else { return }
            if value == 3 {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                viewModel.outputReload.value = 0
            }
        }
    }
}

extension CalendarViewController {
    func setCalendar() {
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scope = .week
        calendar.backgroundColor = .white
        calendar.appearance.headerTitleColor = .systemTeal
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.weekdayFont = .systemFont(ofSize: 14)
        calendar.appearance.titleFont = .systemFont(ofSize: 20)
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.titleTodayColor = .systemOrange
        calendar.appearance.selectionColor = .systemTeal
        calendar.appearance.todayColor = .clear
        calendar.appearance.todaySelectionColor = .systemYellow
        calendar.scrollDirection = .horizontal
    }
    
    @objc func moveButtonTapped(_ sender: MoveNextViewButton) {
        switch sender.kind {
        case .water:
            navigationController?.pushViewController(WaterViewController(), animated: true)
        case .supplement:
            navigationController?.pushViewController(SupplementViewController(), animated: true)
        case .step:
            navigationController?.pushViewController(StepViewController(), animated: true)
        }
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.Topic.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterCollectionViewCell.id, for: indexPath) as! WaterCollectionViewCell
            cell.configureCell(value: viewModel.outputAmountOfDrinksWater.value, selectedDate: calendar.selectedDate)
            cell.waterDetailMoveButton.addTarget(self, action: #selector(moveButtonTapped), for: .touchUpInside)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SupplementLogCollectionViewCell.id, for: indexPath) as! SupplementLogCollectionViewCell
            cell.configureCell(text: viewModel.outputLeftSupplementCount.value, value: viewModel.outputSupplementProgress.value, selectedDate: calendar.selectedDate)
            cell.supplementDetailMoveButton.addTarget(self, action: #selector(moveButtonTapped), for: .touchUpInside)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StepCollectionViewCell.id, for: indexPath) as! StepCollectionViewCell
            cell.configureCell(text: viewModel.outputSteps.value, value: viewModel.outputStepsProgress.value, selectedDate: calendar.selectedDate)
            cell.stepDetailMoveButton.addTarget(self, action: #selector(moveButtonTapped), for: .touchUpInside)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date > Date() {
            showToast("미래의 날짜는 선택할 수 없어요", position: .center)
            calendar.select(Date())
            viewModel.inputSelectDate.value = Date()
        } else {
            viewModel.inputSelectDate.value = date
        }
    }
}
