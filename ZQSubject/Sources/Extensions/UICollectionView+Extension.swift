import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(cls: T.Type, identifier: String = String(describing: T.self)) {
        self.register(cls, forCellWithReuseIdentifier: identifier)
    }

    func registerCellFromNib<T: UICollectionViewCell>(cls: T.Type, identifier: String = String(describing: T.self)) {
        self.register(UINib.init(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: identifier)
    }

    func registerHeaderFooter<T: UICollectionReusableView>(cls: T.Type, kind: String, identifier: String = String(describing: T.self)) {
        self.register(cls, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    func registerHeaderFooterFromNib<T: UICollectionReusableView>(cls: T.Type, kind: String, identifier: String = String(describing: T.self)) {
        self.register(UINib.init(nibName: String(describing: T.self), bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    func dequeueReuseCell<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath, identifier: String = String(describing: T.self)) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Can't dequeue reuseable cell with identifier = \(identifier)")
        }
        return cell
    }

    func dequeueHeaderFooter<T: UICollectionReusableView>(_: T.Type, kind: String, indexPath: IndexPath, identifier: String = String(describing: T.self)) -> T {
        guard let view = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Can't dequeue reuseable HeaderFooterView with identifier = \(identifier)")
        }
        return view
    }
}
