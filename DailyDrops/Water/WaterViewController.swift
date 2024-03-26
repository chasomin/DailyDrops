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
    private lazy var waveView = WaveAnimationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeTop ), frontColor: .backgroundColor, backColor: .pointColor)
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let plusButton = CapsulePointButton(frame: .zero, text: "+ 한 잔")
    private let minusButton = CapsulePointButton(frame: .zero, text: "- 한 잔")
    private let moveButton = UIButton()
    private let emitterLayer = CAEmitterLayer()
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
    
    private func bindData() {
        viewModel.inputViewDidLoad.value = date
        viewModel.outputViewDidLoad.bind { [weak self] (data, goal) in
            guard let self else { return }
            titleLabel.text = Constants.NavigationTitle.Water(goal: Int(goal), cup: Int(data)).title
            navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: plusButton), UIBarButtonItem(customView: minusButton)]
            setUpEmitterLayer()
            changingView(data: data, goal: goal)
            changingLayout(data: data, goal: goal)
        }
        viewModel.outputWaterCount.bind { [weak self] value in
            guard let self, let value else { return }
            countLabel.text = value
        }
        viewModel.outputData.bind { [weak self] (value, goal) in
            guard let self, let value, let goal else { return }
            titleLabel.text = Constants.NavigationTitle.Water(goal: Int(goal), cup: Int(value)).title
            changingView(data: value, goal: goal)
            if viewModel.outputLabelHidden.value == false {
                setAnimation()
                changingLayout(data: value, goal: goal)
            }
        }
        viewModel.outputViewDidDisappear.bind { [weak self] value in
            guard let self, let value else { return }
            waveView.stopAnimation()
        }
        viewModel.outputViewWillAppear.bind { [weak self] value in
            guard let self, let value else { return }
            waveView.startAnimation()
        }
        viewModel.outputLabelHidden.bind { [weak self] value in
            guard let self, let value else { return }
            countLabel.isHidden = value
            navigationController?.navigationBar.tintColor = UIColor.setStatusColor(status: value)
            plusButton.configuration = UIButton.setStatusCapsuleButton(status: value, text: "+ 한 잔")
            minusButton.configuration = UIButton.setStatusCapsuleButton(status: value, text: "- 한 잔")
            showSparkle(status: value)
        }
        viewModel.outputNotToday.bind { [weak self] value in
            guard let self, let value else { return }
            print(value)
            minusButton.isHidden = value
            plusButton.isHidden = value
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = ()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .pointColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.inputViewDidDisappear.value = ()
    }

    override func configureHierarchy() {
        view.addSubview(waveView)
        waveView.addSubview(countLabel)
        waveView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        waveView.snp.makeConstraints { make in
            make.top.equalTo(safeTop)
            make.bottom.equalTo(view)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(15)
        }
    }
    
    override func configureView() {
        titleLabel.font = .largeBoldTitle
        titleLabel.numberOfLines = 2
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
    private func setUpEmitterLayer() {
        let yellowSparkleCell = CAEmitterCell()
        let redSparkleCell = CAEmitterCell()
        let greenSparkleCell = CAEmitterCell()
        yellowSparkleCell.setEmitterCell(image: .sparkle, birth: 50, scale: 1.3)
        redSparkleCell.setEmitterCell(image: .sparkle2, birth: 70, scale: 1)
        greenSparkleCell.setEmitterCell(image: .sparkle3, birth: 50, scale: 1.5)
        emitterLayer.emitterCells = [yellowSparkleCell, redSparkleCell, greenSparkleCell]
    }
    
    private func showSparkle(status: Bool) {
        switch status {
        case true:
            emitterLayer.emitterPosition = CGPoint(x: view.frame.width/2, y: view.frame.height+10)
            emitterLayer.birthRate = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.emitterLayer.birthRate = 0
            }
            view.layer.addSublayer(emitterLayer)
        case false:
            break
        }
    }
    
    private func setAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            countLabel.snp.makeConstraints { make in
                guard let data = self.viewModel.outputData.value.data else { return }
                guard let goal = self.viewModel.outputData.value.goal else { return }
                make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
                make.bottom.equalToSuperview().multipliedBy((1 - (data / goal)) - 0.001)//FIXME: 바닥에 닿으면 다시 안올라오는 이슈 해결......
            }
            view.layoutIfNeeded()
        }
    }
    
    private func changingView(data: Float, goal: Float) {
        waveView.progress = Float(data / goal)
    }
    
    private func changingLayout(data: Float, goal: Float) {
        countLabel.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview().multipliedBy((1 - (data / goal)) - 0.001)//FIXME: 바닥에 닿으면 다시 안올라오는 이슈 해결......
        }
    
    }
}



