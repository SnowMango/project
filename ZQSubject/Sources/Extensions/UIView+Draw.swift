//
//  UIView+Corner.swift
//  TuandaiLoan
//
//  Created by leoli on 2018/10/16.
//  Copyright © 2018 com.tuandaiwang.www. All rights reserved.
//

import UIKit

extension CACornerMask {
    static var layerAllCorners: CACornerMask {
        return  [.layerMinXMinYCorner, .layerMinXMaxYCorner,
                 .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}
extension UIView {
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {

        if #available(iOS 11.0, *) {
            let maps: [UInt : CACornerMask] = [UIRectCorner.topLeft.rawValue:.layerMinXMinYCorner,
                                               UIRectCorner.topRight.rawValue:.layerMinXMaxYCorner,
                                               UIRectCorner.bottomLeft.rawValue:.layerMaxXMinYCorner,
                                               UIRectCorner.bottomRight.rawValue:.layerMaxXMaxYCorner,
                                               UIRectCorner.allCorners.rawValue:.layerAllCorners]
        
            self.layer.maskedCorners = maps[corners.rawValue] ?? .layerAllCorners
            self.layer.cornerRadius = radii
            return
        }
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    /// 画虚线
    ///
    /// - Parameters:
    ///   - lineDashLength: 实现长度
    ///   - lineSpacing: 空白长度
    ///   - lineColor: 实线颜色
    func drawLineOfDash(lineDashLength: Int,
                        lineSpacing: Int,
                        lineColor: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        // 虚线
        shapeLayer.strokeColor = lineColor.cgColor
        // 宽度
        shapeLayer.lineWidth = self.frame.height
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = NSArray(array: [NSNumber(value: lineDashLength), NSNumber(value: lineSpacing)]) as? [NSNumber]
        // 路径
        let path = UIBezierPath()
        let startPointX: CGFloat = 0
        let startPointY: CGFloat = 0
        let endPointX = startPointX + self.frame.width
        let endPointY = startPointY
        path.move(to: CGPoint(x: startPointX, y: startPointY))
        path.addLine(to: CGPoint(x: endPointX, y: endPointY))
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
    }

    
    /// 设置不同位置的不同圆角半径
    /// - Parameters:
    ///   - corners: 设置圆角的信息结构体
    ///   - frame: 指定的frame,可以不传,不传就是view的大小
    func addCorner(_ corners: RectCorner, frame: CGRect? = nil) {
        let rect: CGRect = frame ?? self.bounds
        // 绘制路径
        let path = CGMutablePath()
        let topLeftRadius = corners.topLeft
        let topLeftCenter = CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius)
        path.addArc(center: topLeftCenter, radius: topLeftRadius, startAngle: Double.pi, endAngle: Double.pi * 1.5, clockwise: false)
        let topRightRadius = corners.topRight
        let topRightCenter = CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius)
        path.addArc(center: topRightCenter, radius: topRightRadius, startAngle: Double.pi * 1.5, endAngle: Double.pi * 2, clockwise: false)
        let bottomRightRadius = max(corners.bottomRight, 0)
        let bottomRightCenter = CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius)
        path.addArc(center: bottomRightCenter, radius: bottomRightRadius, startAngle: 0, endAngle: Double.pi * 0.5, clockwise: false)
        let bottomLeftRadius = max(corners.bottomLeft, 0)
        let bottomLeftCenter = CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius)
        path.addArc(center: bottomLeftCenter, radius: bottomLeftRadius, startAngle: Double.pi * 0.5, endAngle: Double.pi, clockwise: false)
        path.closeSubpath()
        // 给layer添加遮罩
        let layer = CAShapeLayer()
        layer.path = path
        self.layer.mask = layer
    }
}

///圆角半径结构体
struct RectCorner {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat
    // 创建四个角不同半径大小的圆角结构体
    init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    // 创建四个角相同半径大小的圆角结构体
    init(all cornerRadius: CGFloat) {
        self.topLeft = cornerRadius
        self.topRight = cornerRadius
        self.bottomLeft = cornerRadius
        self.bottomRight = cornerRadius
    }
}
