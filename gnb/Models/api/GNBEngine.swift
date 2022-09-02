//
//  GNBEngine.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import Foundation

class GNBEngine: GNBRequest {
    
    func downloadRates(completion: @escaping ([GNBRate]?) -> Void) {

        super.descargarRespuesta { (respuesta) in
            if let gnbRate = respuesta as? [GNBRate] {
                completion(gnbRate)
                return
            }
            completion(nil)
            return
        }
    }
    
    func downloadTransactions(completion: @escaping ([GNBTransaction]?) -> Void) {

        super.descargarRespuesta { (respuesta) in
            if let gnbTransaction = respuesta as? [GNBTransaction] {
                completion(gnbTransaction)
                return
            }
            completion(nil)
            return
        }
    }

}
