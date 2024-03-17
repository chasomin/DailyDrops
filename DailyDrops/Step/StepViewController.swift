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
    lazy var todayChartView = TodayStepView(steps: viewModel.outputTodaySteps.value, frame: .zero)
    lazy var weekChartView = WeekStepView(steps: viewModel.outputWeekSteps.value, frame: .zero)
    lazy var monthChartView = MonthStepView(steps: viewModel.outputMonthSteps.value, frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        navigationItem.title = Constants.NavigationTitle.Step(goal: 10000).title //test
        navigationController?.navigationBar.prefersLargeTitles = true
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = ()
    }
    
    override func configureHierarchy() {
        view.addSubview(dateSegment)
        view.addSubview(todayChartView)
        view.addSubview(weekChartView)
        view.addSubview(monthChartView)
    }
    
    override func configureLayout() {
        dateSegment.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        todayChartView.snp.makeConstraints { make in
            make.top.equalTo(dateSegment.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        weekChartView.snp.makeConstraints { make in
            make.top.equalTo(dateSegment.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        monthChartView.snp.makeConstraints { make in
            make.top.equalTo(dateSegment.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
    override func configureView() {
        dateSegment.selectedSegmentTintColor = .pointColor
        dateSegment.insertSegment(withTitle: "1일", at: 0, animated: true)
        dateSegment.insertSegment(withTitle: "1주", at: 1, animated: true)
        dateSegment.insertSegment(withTitle: "1개월", at: 2, animated: true)
        dateSegment.selectedSegmentIndex = 0
        dateSegment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func bindData() {
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
        
        viewModel.outputWeekSteps.bind { [weak self] value in
            guard let self else { return }
            weekChartView.steps = viewModel.outputWeekSteps.value
        }
        
        viewModel.outputMonthSteps.bind { [weak self] value in
            guard let self else { return }
            monthChartView.steps = viewModel.outputWeekSteps.value
        }
        
        viewModel.outputTodaySteps.bind { [weak self] value in
            guard let self else { return }
            todayChartView.steps = viewModel.outputTodaySteps.value
        }
    }
}

extension StepViewController {
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        viewModel.inputSegmentChanged.value = sender.selectedSegmentIndex
    }
}
