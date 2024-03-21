//
//  BaseViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
    }
    
    func configureLayout() {
    }
    
    func configureView() {
    }
}

