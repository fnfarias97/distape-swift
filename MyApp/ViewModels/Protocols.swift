//
//  Protocols.swift
//  MyApp
//
//  Created by Fernando Farias on 04/11/2021.
//

import Foundation
import UIKit

protocol ButtonOnCellDelegate: AnyObject {
    func buttonTouchedOnCell (myTableViewCell: UITableViewCell)
}

protocol PlayButtonDelegate: AnyObject {
    func playButtonTouched (indexPath: IndexPath)
}
