//
//  StepViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/17/24.
//

import UIKit
import SnapKit

final class StepViewController: BaseViewController {
    let viewModel = StepViewModel()
    let dateSegment = UISegmentedControl()
    let todayChartView = TodayStepView()
    let weekChartView = WeekStepView()
    let monthChartView = MonthStepView()
    let titleLabel = UILabel()
    let stepLabel = UILabel()
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
        
    override func configureHierarchy() {
        view.addSubview(dateSegment)
        view.addSubview(todayChartView)
        view.addSubview(weekChartView)
        view.addSubview(monthChartView)
        view.addSubview(titleLabel)
        view.addSubview(stepLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(15)
        }
        dateSegment.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        stepLabel.snp.makeConstraints { make in
            make.top.equalTo(dateSegment.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        todayChartView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        weekChartView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        monthChartView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
    override func configureView() {
        titleLabel.font = .largeBoldTitle
        titleLabel.numberOfLines = 2
//        stepLabel.text = "총 10000걸음"
        stepLabel.font = .boldTitle
        dateSegment.selectedSegmentTintColor = .pointColor
        dateSegment.insertSegment(withTitle: "1일", at: 0, animated: true)
        dateSegment.insertSegment(withTitle: "1주", at: 1, animated: true)
        dateSegment.insertSegment(withTitle: "1개월", at: 2, animated: true)
        dateSegment.selectedSegmentIndex = 0
        dateSegment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func bindData() {
        viewModel.inputViewDidLoad.value = date
        
        viewModel.outputGoal.bind { [weak self] value in
            guard let self, let value else { return }
            titleLabel.text = Constants.NavigationTitle.Step(goal: value).title
        }
        
        viewModel.outputSegmentChanged.bind { [weak self] value in
            guard let self else { return }
            switch value {
            case 0:
                todayChartView.isHidden = false
                weekChartView.isHidden = true
                monthChartView.isHidden = true
            case 1:
                todayChartView.isHidden = true
                weekChartView.isHidden = false
                monthChartView.isHidden = true
            case 2:
                todayChartView.isHidden = true
                weekChartView.isHidden = true
                monthChartView.isHidden = false
            default:
                return
            }
        }
        
        viewModel.outputTodaySteps.bind { [weak self] value in
            guard let self else { return }
            DispatchQueue.main.async {
                self.todayChartView.setDataCount(value, range: UInt32(10000))
            }
        }
        
        viewModel.outputWeekSteps.bind { [weak self] value in
            guard let self else { return }
            DispatchQueue.main.async {
                self.weekChartView.setDataCount(value, range: UInt32(10000))
            }
        }

        viewModel.outputMonthSteps.bind { [weak self] value in
            guard let self else { return }
            DispatchQueue.main.async {
                self.monthChartView.setDataCount(value, range: UInt32(10000))
            }
        }
        
        viewModel.outputTotalSteps.bind { [weak self] value in
            guard let self, let value else { return }
            DispatchQueue.main.async {
                self.stepLabel.text = "\(value)"
            }
        }
    }
}

extension StepViewController {
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        viewModel.inputSegmentChanged.value = sender.selectedSegmentIndex
    }
}
