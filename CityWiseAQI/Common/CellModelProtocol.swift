//
//  CellModelProtocol.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation
import UIKit

// MARK: - Cell Model -
public protocol CellModelProtocol {
    // Reuse identifier
    var reuseIdentifier: String {get set}
    // Variable height support
    var height: CGFloat {get set}
    var estimatedhHeight: CGFloat {get set}
    var isSectionLastCell: Bool {get set}
    var isSectionFirstCell: Bool {get set}
    var isDeleteOnSwipe: Bool {get set}
}

// MARK: - Configuration -
public protocol ConfigurableView {
    func configure(_ cellModel:CellModelProtocol)
}

// MARK: - Registration (Identifier) -
public protocol ReusableView {
    static var identifier:String { get }
}

extension ReusableView where Self: UIView {
    public static var identifier: String {
        return String(describing: self)
    }
}

// MARK: - Registration (NibName) -
public protocol NibLoadableView {
    static var nibName:String {get}
}

extension NibLoadableView {
    public static var nibName:String {
        return String(describing: self)
    }
}

// MARK: - UITableViewCell Extension -
extension UITableViewCell : ReusableView {
}

// MARK: - UITableView Extension -
extension UITableView {
    public func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        register(UINib(nibName: T.nibName, bundle: Bundle(for:T.self)), forCellReuseIdentifier: T.identifier)
//        register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.identifier)
    }

    public func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView, T: NibLoadableView {
//        register(UINib(nibName: T.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: T.identifier)
        register(UINib(nibName: T.nibName, bundle: Bundle(for:T.self)), forHeaderFooterViewReuseIdentifier: T.identifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath:IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T {
            return cell
        }
        fatalError("Could not dequeue cell with identifier: \(T.identifier)")
    }
}


// MARK: - UITableView Extension -
extension UICollectionViewCell: ReusableView {
}

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadableView {
//        register(UINib(nibName: T.nibName, bundle: nil), forCellWithReuseIdentifier: T.identifier)
        register(UINib(nibName: T.nibName, bundle: Bundle(for:T.self)), forCellWithReuseIdentifier: T.identifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath:IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T {
            return cell
        }
        fatalError("Could not dequeue cell with identifier: \(T.identifier)")
    }
}

