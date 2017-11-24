//
//  ScratchMask.swift
//  刮刮卡Demo
//
//  Created by cofco on 2017/11/24.
//  Copyright © 2017年 cofco. All rights reserved.
//

import UIKit

@objc protocol ScratchCardDelegate {
    @objc optional func scratchBegan(point:CGPoint)
    @objc optional func scratchMoved(progress:Float)
    @objc optional func scratchEnded(point:CGPoint)
}

class ScratchMask: UIImageView {

    weak var delegate:ScratchCardDelegate?
    
    var lineType:CGLineCap!
    
    var lineWidth:CGFloat!
    
    var lastPoint:CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        lastPoint = touch.location(in: self)
        
        delegate?.scratchBegan?(point: lastPoint!)
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,let point = lastPoint,let img = image else {
            return
        }
        let newPoint = touch.location(in: self)
        
        eraseMask(fromPoint: point, toPoint: newPoint)
        // 保存最新触点坐标，供下次使用
        lastPoint = newPoint
        
        // 计算刮开面积的百分比
        let progress = getAlphaPixelPercent(img: img)
        // 调用相应的代理方法
        delegate?.scratchMoved?(progress: progress)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else {
            return
        }
        delegate?.scratchEnded?(point: lastPoint!)
    }
    
    // 清除两点间的图层
    func eraseMask(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        image?.draw(in: self.bounds)
        // 再绘制线条
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineType)
        context.setLineWidth(lineWidth)
        // 混合模式设为清除
        context.setBlendMode(.clear)
        context.addPath(path)
        context.strokePath()
        
        // 将二者混合后的图片显示出来
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    // 获取透明像素占总像素的百分比
    private func getAlphaPixelPercent(img:UIImage) -> Float {
        // 计算像素个数
        let width = Int(img.size.width)
        let height = Int(img.size.height)
        let bitmapByteCount = width * height
        // 得到所有像素数据
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext.init(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGBitmapInfo.init(rawValue: CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(rect)
        context.draw(img.cgImage!, in: rect)
        
        // 计算透明像素个数
        var alphaPixelCount = 0
        for x in 0...Int(width) {
            for y in 0...Int(height) {
                if (pixelData[y * width + x] == 0) {
                    alphaPixelCount += 1
                }
            }
        }
        free(pixelData)
        return Float(alphaPixelCount) / Float(bitmapByteCount)
    }
}
