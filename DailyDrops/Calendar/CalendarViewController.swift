//
//  CalendarViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/18/24.
//

import UIKit
import FSCalendar

class CalendarViewController: BaseViewController {
    let calendar = FSCalendar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        calendar.dataSource = self
        calendar.currentPage = Date()
        calendar.select(Date())

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WaterCollectionViewCell.self, forCellWithReuseIdentifier: WaterCollectionViewCell.id)
        collectionView.register(SupplementLogCollectionViewCell.self, forCellWithReuseIdentifier: SupplementLogCollectionViewCell.id)
        collectionView.register(StepCollectionViewCell.self, forCellWithReuseIdentifier: StepCollectionViewCell.id)

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
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterCollectionViewCell.id, for: indexPath) as! WaterCollectionViewCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SupplementLogCollectionViewCell.id, for: indexPath) as! SupplementLogCollectionViewCell
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StepCollectionViewCell.id, for: indexPath) as! StepCollectionViewCell
            return cell

        default:
            return UICollectionViewCell()
        }
    }
    
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
}
