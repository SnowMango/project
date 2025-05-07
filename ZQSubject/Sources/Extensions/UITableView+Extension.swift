//
//  UITableView+Extension.swift
//  BaseProject
//
//  Created by Dason on 2020/2/19.
//  Copyright © 2020 Dason. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(cls: T.Type, identifier: String = String(describing: T.self)) {
        self.register(cls, forCellReuseIdentifier: identifier)
    }

    func registerCellFromNib<T: UITableViewCell>(cls: T.Type, identifier: String = String(describing: T.self)) {
        self.register(UINib.init(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: identifier)
    }

    func registerHeaderFooter<T: UITableViewHeaderFooterView>(cls: T.Type, identifier: String = String(describing: T.self)) {
        self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func registerHeaderFooterFromNib<T: UITableViewHeaderFooterView>(cls: T.Type, identifier: String = String(describing: T.self)) {
        self.register(UINib.init(nibName: String(describing: T.self), bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }

    func dequeueReuseCell<T: UITableViewCell>(_: T.Type, indexPath: IndexPath, identifier: String = String(describing: T.self)) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Can't dequeue reuseable cell with identifier = \(identifier)")
        }
        return cell
    }

    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type, identifier: String = String(describing: T.self)) -> T {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Can't dequeue reuseable HeaderFooterView with identifier = \(identifier)")
        }
        return view
    }
}
