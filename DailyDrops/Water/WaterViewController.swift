//
//  WaterViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/8/24.
//

import UIKit
import WaveAnimationView
import SnapKit

final class WaterViewController: BaseViewController {
    private let viewModel = WaterViewModel()
    private let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    private lazy var window = windowScene?.windows.first
    private lazy var safeTop = window?.safeAreaInsets.top ?? 0 + (self.navigationController?.navigationBar.frame.height ?? 0)   // safeArea + Navigation
    private lazy var safeBottom = window?.safeAreaInsets.bottom ?? 0
    private lazy var waveView = WaveAnimationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeTop ), frontColor: .white, backColor: .systemTeal)
    private let countLabel = UILabel()
    private let plusButton = CapsulePointBarButton(frame: .zero, text: "+ 한 잔")
    private let minusButton = CapsulePointBarButton(frame: .zero, text: "- 한 잔")
        
    override func viewDidLoad() {
        super.viewDidLoad()

        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = ()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.inputViewDidDisappear.value = ()
    }

    override func configureHierarchy() {
        view.addSubview(waveView)
        waveView.addSubview(countLabel)
    }
    
    override func configureLayout() {
        waveView.snp.makeConstraints { make in
            make.top.equalTo(safeTop)
            make.bottom.equalTo(view)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        countLabel.snp.makeConstraints { make in
           let data = viewModel.outputViewDidLoad.value.0
            let goal = viewModel.outputViewDidLoad.value.1
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview().multipliedBy(1 - (data / goal))
        }
    }
    
    override func configureView() {
        let data = viewModel.outputViewDidLoad.value.0
         let goal = viewModel.outputViewDidLoad.value.1

        waveView.progress = data / goal
        countLabel.text = "\(Int(goal - data))잔 남았어요!"

        countLabel.textColor = .titleColor
        countLabel.font = .boldTitle
        countLabel.textAlignment = .right
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
}

extension WaterViewController {
    @objc func plusButtonTapped() {
        viewModel.inputPlusButtonTapped.value = ()
    }
    
    @objc func minusButtonTapped() {
        viewModel.inputMinusButtonTapped.value = ()
    }
}

extension WaterViewController {
    private func bindData() {
        viewModel.inputViewDidLoad.value = ()
        viewModel.outputViewDidLoad.bind { [weak self] (data, goal) in
            guard let self else { return }
            navigationItem.title = "목표! \(Int(goal))잔 마시기"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: plusButton), UIBarButtonItem(customView: minusButton)]
        }
        viewModel.outputData.bind { [weak self] (value, goal) in
            guard let self, let value, let goal else { return }
            setAnimation()
            changingView(data: value, goal: goal)
        }
        viewModel.outputViewDidDisappear.bind { [weak self] value in
            guard let self, let value else { return }
            waveView.stopAnimation()
            print("disappear")
        }
        viewModel.outputViewWillAppear.bind { [weak self] value in
            guard let self, let value else { return }
            waveView.startAnimation()
            print("appear")
        }
    }
    
    private func setAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            countLabel.snp.makeConstraints { make in
                guard let data = self.viewModel.outputData.value.0 else { return }
                guard let goal = self.viewModel.outputData.value.1 else { return }
                make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
                make.bottom.equalToSuperview().multipliedBy(1 - (data / goal))
            }
            view.layoutIfNeeded()
        }
    }
    
    private func changingView(data: Float, goal: Float) {
        countLabel.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            guard let data = viewModel.outputData.value.0 else { return }
            guard let goal = viewModel.outputData.value.1 else { return }
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview().multipliedBy(1 - (data / goal))
        }
        waveView.progress = Float(data / goal)
        countLabel.text = "\(Int(goal - data))잔 남았어요!"
    }
}

