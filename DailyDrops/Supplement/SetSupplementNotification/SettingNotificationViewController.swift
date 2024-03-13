//
//  SettingNotificationViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/9/24.
//

import UIKit
import SnapKit

final class SettingNotificationViewController: BaseViewController {
    
    private let viewModel = SettingNotificationViewModel()

    private let nameTitleLabel = UILabel()
    private let nameSubTitleLabel = UILabel()
    private let nameTextField = UITextField()
    private let nameSearchButton = UIButton()
    private let searchHStack = UIStackView()
    private let nameVStack = UIStackView()
    
    private let weekTitleLabel = UILabel()
    private let monButton = UIButton()
    private let tueButton = UIButton()
    private let wedButton = UIButton()
    private let thuButton = UIButton()
    private let friButton = UIButton()
    private let satButton = UIButton()
    private let sunButton = UIButton()
    private lazy var weekButtons: [UIButton] = [monButton, tueButton, wedButton, thuButton, friButton, satButton, sunButton]
    private let weekHStack = UIStackView()
    private let weekVStack = UIStackView()
    
    private let repeatTitleLabel = UILabel()
    private let repeatSubTitleLabel = UILabel()
    private let repeatSegment = UISegmentedControl()
    private let repeatVStack = UIStackView()
    
    private let firstTitle = UILabel()
    private let secondTitle = UILabel()
    private let thirdTitle = UILabel()
    private let firstDatepicker = UIDatePicker()
    private let secondDatePicker = UIDatePicker()
    private let thirdDatePicker = UIDatePicker()
    private let firstHStack = UIStackView()
    private let secondHStack = UIStackView()
    private let thirdHStack = UIStackView()
    private let hourVStack = UIStackView()
    
    private let VStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func configureHierarchy() {
        view.addSubview(VStack)
        VStack.addArrangedSubview(nameVStack)
        VStack.addArrangedSubview(weekVStack)
        VStack.addArrangedSubview(repeatVStack)
        VStack.addArrangedSubview(hourVStack)
        nameVStack.addArrangedSubview(nameTitleLabel)
        nameVStack.addArrangedSubview(nameSubTitleLabel)
        nameVStack.addArrangedSubview(searchHStack)
        searchHStack.addArrangedSubview(nameTextField)
        searchHStack.addArrangedSubview(nameSearchButton)
        weekVStack.addArrangedSubview(weekTitleLabel)
        weekVStack.addArrangedSubview(weekHStack)
        weekButtons.forEach {
            weekHStack.addArrangedSubview($0)
        }
        repeatVStack.addArrangedSubview(repeatTitleLabel)
        repeatVStack.addArrangedSubview(repeatSubTitleLabel)
        repeatVStack.addArrangedSubview(repeatSegment)
        hourVStack.addArrangedSubview(firstHStack)
        hourVStack.addArrangedSubview(secondHStack)
        hourVStack.addArrangedSubview(thirdHStack)
        firstHStack.addArrangedSubview(firstTitle)
        firstHStack.addArrangedSubview(firstDatepicker)
        secondHStack.addArrangedSubview(secondTitle)
        secondHStack.addArrangedSubview(secondDatePicker)
        thirdHStack.addArrangedSubview(thirdTitle)
        thirdHStack.addArrangedSubview(thirdDatePicker)
    }
    
    override func configureLayout() {
        VStack.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
    override func configureView() {
        nameTitleLabel.text = "어떤 영양제를 드시나요?"
        nameTitleLabel.font = .title
        nameSubTitleLabel.text = "나의 영양제를 검색해서 섭취량과 횟수를 추천받아볼 수도 있어요!"
        nameSubTitleLabel.font = .caption
        nameSubTitleLabel.textColor = .secondaryLabel
        nameTextField.placeholder = "영양제 이름"
        nameTextField.font = .body
        nameSearchButton.setTitle("", for: .normal)
        nameSearchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        nameSearchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        weekTitleLabel.text = "무슨 요일에 드시나요?"
        weekTitleLabel.font = .title
        for i in 0..<weekButtons.count {
            weekButtons[i].tag = i
            weekButtons[i].addTarget(self, action: #selector(weekButtonTapped), for: .touchUpInside)
        }
        repeatTitleLabel.text = "하루에 몇 번 복용하시나요?"
        repeatTitleLabel.font = .title
        repeatSubTitleLabel.text = "최대 3번까지 선택 가능합니다."
        repeatSubTitleLabel.font = .callout
        repeatSubTitleLabel.textColor = .subTitleColor
        repeatSegment.selectedSegmentTintColor = .pointColor
        repeatSegment.insertSegment(withTitle: "1", at: 0, animated: true)
        repeatSegment.insertSegment(withTitle: "2", at: 1, animated: true)
        repeatSegment.insertSegment(withTitle: "3", at: 2, animated: true)
        repeatSegment.selectedSegmentIndex = 0
        repeatSegment.addTarget(self, action: #selector(segmentChaged), for: .valueChanged)
        firstDatepicker.datePickerMode = .time
        firstDatepicker.preferredDatePickerStyle = .compact
        secondDatePicker.datePickerMode = .time
        secondDatePicker.preferredDatePickerStyle = .compact
        thirdDatePicker.datePickerMode = .time
        thirdDatePicker.preferredDatePickerStyle = .compact
        firstTitle.text = "1회차"
        firstTitle.font = .title
        secondTitle.text = "2회차"  
        secondTitle.font = .title
        thirdTitle.text = "3회차"
        thirdTitle.font = .title

        
        VStack.axis = .vertical
        VStack.spacing = 50
        VStack.distribution = .equalSpacing
        
        nameVStack.axis = .vertical
        nameVStack.spacing = 10
        nameVStack.distribution = .equalSpacing
        
        searchHStack.axis = .horizontal
        searchHStack.spacing = 5
        searchHStack.distribution = .equalSpacing
        
        weekVStack.axis = .vertical
        weekVStack.spacing = 10
        weekVStack.distribution = .equalSpacing
        
        weekHStack.axis = .horizontal
        weekHStack.spacing = 5
        weekHStack.distribution = .equalSpacing
        
        repeatVStack.axis = .vertical
        repeatVStack.spacing = 10
        repeatVStack.distribution = .equalSpacing
        
        hourVStack.axis = .vertical
        hourVStack.spacing = 10
        hourVStack.distribution = .equalSpacing
        
        firstHStack.axis = .horizontal
        firstHStack.distribution = .fill
        
        secondHStack.axis = .horizontal
        secondHStack.distribution = .fill
        
        thirdHStack.axis = .horizontal
        thirdHStack.distribution = .fill
    }

    private func bindData() {
        viewModel.inputViewDidLoad.value = ()
        
        viewModel.outputWeekButtonTapped.bind { [weak self] value in
            guard let self else { return }
            weekButtons.forEach {
                var isActive = value.contains($0.tag)
                $0.configuration = $0.isTapped(value: isActive, text: Constants.WeekButtonTitle.allCases[$0.tag].rawValue)
            }
        }
        
        viewModel.outputSegmentTapped.bind { [weak self] value in
            guard let self, let value else { return }
            if value == Constants.AlarmRepeatCount.first.rawValue {
                firstHStack.isHidden = false
                secondHStack.isHidden = true
                thirdHStack.isHidden = true
            } else if value == Constants.AlarmRepeatCount.second.rawValue {
                firstHStack.isHidden = false
                secondHStack.isHidden = false
                thirdHStack.isHidden = true
            } else {
                firstHStack.isHidden = false
                secondHStack.isHidden = false
                thirdHStack.isHidden = false
            }
        }
        
        viewModel.outputSetNavigation.bind { [weak self] _ in
            guard let self else { return }
            navigationItem.title = Constants.NavigationTitle.SetNotification.title
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        }
        
        viewModel.outputSearchButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            view.endEditing(true)
            let vc = SearchViewController()
            vc.delegate = self
            vc.searchText = nameTextField.text
            navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.outputSaveButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            navigationController?.popViewController(animated: true)
        }
    }
}

extension SettingNotificationViewController {
    @objc func searchButtonTapped() {
        viewModel.inputSearchButtonTapped.value = ()
    }
    
    @objc func weekButtonTapped(_ sender: UIButton) {
        viewModel.inputWeekButtonTapped.value = sender.tag
    }
    
    @objc func segmentChaged(_ sender: UISegmentedControl) {
        viewModel.inputSegmentTapped.value = sender.selectedSegmentIndex
    }
    
    @objc func saveButtonTapped() {
        guard let name = nameTextField.text else { return }
        let days: [Int] = viewModel.outputWeekButtonTapped.value
        let times: [Date] = [firstDatepicker.date, secondDatePicker.date, thirdDatePicker.date]
        viewModel.inputSaveButtonTapped.value = MySupplement(name: name, days: days, times: times)
    }
}

extension SettingNotificationViewController: TransitionValue {
    func transition(value: String) {
        nameTextField.text = value
    }
}


