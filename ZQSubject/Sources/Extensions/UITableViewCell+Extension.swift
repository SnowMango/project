//
//  UITableViewCell+Extension.swift
//  rich
//
//  Created by Dason on 2022/6/28.
//  Copyright © 2022 sdr. All rights reserved.
//

import Foundation
import UIKit
//cell所在table的位置
enum TableViewCellPosition {
    case top        //顶部(第一行)
    case middle     //中间
    case bottom     //底部(最后一行)
    case onlyOne    //只有一行数据
    
    //通过传入的数据个数,计算位置
    static func getPosition(total: Int, current: Int) -> Self? {
        if total == 0 {
            return nil
        } else if total == 1 {
            return .onlyOne
        } else {
            switch current {
            case 0://第一行
                return .top
            case total-1://最后一行
                return .bottom
            default:
                return .middle
            }
        }
    }
}

extension UITableViewCell {
    
    /// 设置cell的圆角,使用的时候记得设置setNeedsDisplay(),cell重用的时候才能更新圆角
    /// - Parameters:
    ///   - rowPos: cell位于tableview的什么位置,根据位置设置对应的圆角
    ///   - container: cell的背景视图(一般是我们自己创建的有视觉效果的视图)
    ///   - radius: 圆角半径
    func containerCorner(rowPos: TableViewCellPosition?, container: UIView, radius: CGFloat) {
        guard let rowPos = rowPos else {
            return
        }
        switch rowPos {
        case .onlyOne:
            container.corner(byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radii: radius)
        case .middle:
            container.layer.mask = nil
        case .top:
            container.corner(byRoundingCorners: [.topLeft, .topRight], radii: radius)
        case .bottom:
            container.corner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: radius)
        }
    }
}

