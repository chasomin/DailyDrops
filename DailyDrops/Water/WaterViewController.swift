//
//  WaterViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/8/24.
//

import UIKit
import WaveAnimationView
import SnapKit

//TODO: Realm
final class WaterViewController: BaseViewController {
    private let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    private lazy var window = windowScene?.windows.first
    private lazy var safeTop = window?.safeAreaInsets.top ?? 0 + (self.navigationController?.navigationBar.frame.height ?? 0)   // safeArea + Navigation
    private lazy var safeBottom = window?.safeAreaInsets.bottom ?? 0
    
    private lazy var waveView = WaveAnimationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeTop ), frontColor: .white, backColor: .systemTeal)
    private let countLabel = UILabel()
    private let plusButton = CapsulePointBarButton(frame: .zero, text: "+ 한 잔")
    private let minusButton = CapsulePointBarButton(frame: .zero, text: "- 한 잔")

    private let goalTest: Float = 20
    private var currentTest: Float = 1 {
        didSet {
            configureLayout()
            changingView()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waveView.startAnimation()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "목표! \(Int(goalTest))잔 마시기"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: plusButton), UIBarButtonItem(customView: minusButton)]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        waveView.stopAnimation()
        
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
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview().multipliedBy(1 - (currentTest / goalTest))
        }
    }
    
    override func configureView() {
        countLabel.textColor = .titleColor
        countLabel.font = .boldTitle
        countLabel.textAlignment = .right
        changingView()
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
    
    func changingView() {
        waveView.progress = currentTest / goalTest
        countLabel.text = "\(Int(goalTest - currentTest))잔 남았어요!"
    }
    
    
    @objc func plusButtonTapped() {
        currentTest += 1

        setAnimation()
    }
    
    @objc func minusButtonTapped() {
        currentTest -= 1
        setAnimation()
    }
    private func setAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            configureLayout()
            
            view.layoutIfNeeded()

        }
    }
}
