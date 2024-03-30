//
//  StepGoalSettingViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/20/24.
//

import UIKit
import SnapKit

final class StepGoalSettingViewController: BaseViewController {
    private let viewModel = StepGoalSettingViewModel()

    private let titleLabel = UILabel()
    private let goalStack = UIStackView()
    private let goalTextField = UITextField()
    private let stepLabel = UILabel()
    private let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.inputGoalViewDidLoad.value = ()
        bindData()
        goalTextField.delegate = self
    }
    
    private func bindData() {
        viewModel.outputGoal.bind { [weak self] value in
            guard let self, let value else { return }
            goalTextField.text = "\(value)"
        }
        
        viewModel.outputInvalid.bind { [weak self] value in
            guard let self, let value else { return }
            goalTextField.deleteBackward()
            showToast(value, position: .top)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.inputGoalViewDidDisappear.value = goalTextField.text
    }

    override func configureHierarchy() {
        view.addGestureRecognizer(tapGesture)
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
        goalTextField.textAlignment = .center
        goalTextField.borderStyle = .roundedRect
        goalTextField.keyboardType = .numberPad
        
        stepLabel.text = "걸음"
        stepLabel.font = .title
        
        tapGesture.addTarget(self, action: #selector(tapGestureTapped))
    }
}

extension StepGoalSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.inputTextFieldValueChanged.value = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }
}

extension StepGoalSettingViewController {
    @objc func tapGestureTapped() {
        view.endEditing(true)
    }
}
