//
//  WaterGoalSettingViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/20/24.
//

import UIKit
import SnapKit

final class WaterGoalSettingViewController: BaseViewController {
    private let viewModel = WaterGoalSettingViewModel()

    private let titleLabel = UILabel()
    private let goalStack = UIStackView()
    private let goalLabel = UILabel()
    private let cupLabel = UILabel()
    private let stepper = UIStepper()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.inputGoalViewDidLoad.value = ()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputGoal.bind { [weak self] value in
            guard let self, let value else { return }
            goalLabel.text = "\(value)"
            stepper.value = Double(value)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.inputGoalViewDidDisappear.value = goalLabel.text
    }
    
    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(goalStack)
        goalStack.addArrangedSubview(goalLabel)
        goalStack.addArrangedSubview(cupLabel)
        view.addSubview(stepper)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        goalStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(100)
        }
        
        stepper.snp.makeConstraints { make in
            make.top.equalTo(goalStack.snp.bottom).offset(30)
            make.centerX.equalTo(view)
        }
    }
    
    override func configureView() {
        goalStack.spacing = 10
        goalStack.axis = .horizontal
        goalStack.alignment = .bottom
        goalStack.distribution = .equalSpacing
        
        titleLabel.text = "하루 물 목표 섭취량"
        titleLabel.font = .boldTitle
        
        goalLabel.font = .bigBoldTitle
        goalLabel.textAlignment = .center
        cupLabel.text = "잔"
        cupLabel.font = .title
        
        stepper.minimumValue = 0
        stepper.maximumValue = 20
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(stepperTapped), for: .valueChanged)
    }
}

extension WaterGoalSettingViewController {
    @objc func stepperTapped(_ sender: UIStepper) {
        goalLabel.text = "\(Int(sender.value))"
    }
}
