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
    private let goalTest: Float = 20
    private var currentTest: Float = 1
    //setNeedsDisplay()?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waveView.startAnimation()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "목표! \(Int(goalTest))잔 마시기"
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
        waveView.setProgress(currentTest / goalTest)

        countLabel.textColor = .titleColor
        countLabel.text = "\(Int(goalTest - currentTest))잔 남았어요!"
        countLabel.font = .boldTitle
        countLabel.textAlignment = .right
        waveView.startAnimation()
    }
}
