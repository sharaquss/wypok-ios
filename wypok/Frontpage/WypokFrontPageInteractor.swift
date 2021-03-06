//
//  WypokFrontPageInteractor.swift
//  wypok
//
//  Created by Przemyslaw Jablonski on 03/08/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import Foundation

class WypokFrontPageInteractor: FrontPageInteractor {
    
    //todo: maybe service should be part of some baseInteractor? this will be everywhere anyway
    private let service: FrontPageService
    
    init(_ service: FrontPageService) {
        self.service = service
    }
    
    func getFrontPageItems(and action: @escaping FrontPageInteractor.ItemsFetchedClosure) {
        service.getLinksPromoted(and: { dtos in
            action(dtos.flatMap({ dto in dto.map() }))
        }, fetchDidFailed: {_ in
            
        })
    }
    
}
