//
//  ViewController.swift
//  DailyDrops
//
//  Created by 차소민 on 3/7/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let label = UILabel()
    let labelPre = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(label)
        view.addSubview(labelPre)
        let list = ["1"]
        label.text = list[1]
        labelPre.text = "프리텐다드"
        
        label.font = .boldSystemFont(ofSize: 34)
        labelPre.font = .largeBoldTitle
        
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        labelPre.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    
    
    
    
    
    
}
