//
//  StepGoalSettingViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/20/24.
//

import UIKit
import SnapKit

final class StepGoalSettingViewController: BaseViewController {
    private let titleLabel = UILabel()
    private let goalStack = UIStackView()
    private let goalTextField = UITextField()
    private let stepLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SettingViewModel.shared.inputViewDidLoad.value = .stepGoal
        bindData()
        goalTextField.delegate = self
    }
    
    private func bindData() {
        SettingViewModel.shared.outputGoal.bind { [weak self] value in
            guard let self, let value else { return }
            goalTextField.text = "\(value)"
        }
        
        SettingViewModel.shared.outputInvaild.bind { [weak self] value in
            guard let self, let value else { return }
            goalTextField.deleteBackward()
            showToast(value, position: .top)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SettingViewModel.shared.inputViewDidDisappear.value = (kind: .stepGoal, goalValue: goalTextField.text)
    }

    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(goalStack)
        goalStack.addArrangedSubview(goalTextField)
        goalStack.addArrangedSubview(stepLabel)
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
    }
    
    override func configureView() {
        goalStack.spacing = 10
        goalStack.axis = .horizontal
        goalStack.alignment = .bottom
        goalStack.distribution = .equalSpacing
        
        titleLabel.text = "하루 목표 걸음"
        titleLabel.font = .boldTitle
        
        goalTextField.font = .bigBoldTitle
        goalTextField.borderStyle = .roundedRect
        goalTextField.keyboardType = .numberPad
        
        stepLabel.text = "걸음"
        stepLabel.font = .title
        
    }
}

extension StepGoalSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        SettingViewModel.shared.inputTextFieldValueChanged.value = textField.text
    }
}
