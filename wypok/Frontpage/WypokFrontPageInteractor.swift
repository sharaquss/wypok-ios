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
    private let service: FrontPageService = WypokService() //todo: violation of DI
    
    func getFrontPageItems(and action: @escaping FrontPageInteractor.ItemsFetchedClosure) {
        service.getLinksPromoted { dtos in
            action(dtos.map({ dto in dto.mapToLocal() }))
        }
    }
    
//    frontPageService.getLinksPromoted(response: { dtos in
//    completion(dtos.map({ dto in dto.mapToLocal()}))
//    })
    
}
