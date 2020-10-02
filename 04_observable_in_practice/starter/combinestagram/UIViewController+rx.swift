//
//  UIViewController+rx.swift
//  Combinestagram
//
//  Created by Karol Harasim on 02/10/2020.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {
  func alert(title: String?, text: String?) -> Completable {
    return Completable.create { [weak self] completable in
      let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
        completable(.completed)
      }))
      self?.present(alert, animated: true, completion: nil)
      return Disposables.create {
        self?.dismiss(animated: true)
      }
    }
  }
}
