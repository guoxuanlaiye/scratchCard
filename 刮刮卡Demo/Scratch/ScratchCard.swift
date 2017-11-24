//
//  ScratchCard.swift
//  刮刮卡Demo
//
//  Created by cofco on 2017/11/24.
//  Copyright © 2017年 cofco. All rights reserved.
//

import UIKit



class ScratchCard: UIView {
    // 涂层
    var scratchMask:ScratchMask!
    // 底层劵面图片
    var couponImgV:UIImageView!
    
    weak var delegate:ScratchCardDelegate? {
        didSet {
            scratchMask.delegate = delegate
        }
    }
    /*
     scratchWidth:画笔粗细
     scratchType:画笔样式
     */
    public init(frame: CGRect,couponImage:UIImage,maskImage:UIImage,scratchWidth:CGFloat = 15,scratchType:CGLineCap = .round) {
        
        super.init(frame:frame)
        let childFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        // 添加底层劵面
        couponImgV = UIImageView(frame: childFrame)
        couponImgV.image = couponImage
        self.addSubview(couponImgV)
        
        scratchMask = ScratchMask(frame: childFrame)
        scratchMask.image = maskImage
        scratchMask.lineWidth = scratchWidth
        scratchMask.lineType = scratchType
        self.addSubview(scratchMask)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
