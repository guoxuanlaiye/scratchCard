//
//  ViewController.swift
//  刮刮卡Demo
//
//  Created by cofco on 2017/11/24.
//  Copyright © 2017年 cofco. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ScratchCardDelegate {

    var scratchCard:ScratchCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scratchCard = ScratchCard(frame: CGRect.init(x: 20.0, y: 80.0, width: 241.0, height: 106.0), couponImage: UIImage.init(named: "coupon.png")!, maskImage: UIImage.init(named: "mask.png")!)
        scratchCard.delegate = self
        self.view.addSubview(scratchCard)
    }

    func scratchBegan(point: CGPoint) {
        print("开始刮奖:\(point)")
    }
    func scratchMoved(progress: Float) {
        print("--- 当前进度:\(progress)")
        // 可以在这设置当到达某个进度时展示全部
        if progress > 0.4 {
            scratchCard.scratchMask.alpha = 0
        }
    }
    func scratchEnded(point: CGPoint) {
        print("停止刮奖:\(point)")

    }


}

