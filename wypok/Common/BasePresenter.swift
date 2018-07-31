//
//  BasePresenter.swift
//  wypok
//
//  Created by Przemyslaw Jablonski on 25/07/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import Foundation

class BasePresenter<VS: Any>: Presenter {
    
    private var view: View? = nil
    
    final func attach(_ view: View) {
        self.view = view
        onAttached(view: view)
    }
    
    final func detach(_ view: View) {
        self.view = nil
        onDetached(view: view)
    }
    
    func onAttached(view: View) {
        fatalError()
    }
    
    func onDetached(view: View) {
        fatalError()
    }
    
}