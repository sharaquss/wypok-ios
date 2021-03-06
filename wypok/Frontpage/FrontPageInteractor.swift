//
//  FrontPageInteractor.swift
//  wypok
//
//  Created by Przemyslaw Jablonski on 02/08/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import Foundation


protocol FrontPageInteractor {
    
    typealias ItemsFetchedClosure = ([FrontPageItemModel]) -> ()
    
    func getFrontPageItems(and perform: @escaping ItemsFetchedClosure)
    
}
