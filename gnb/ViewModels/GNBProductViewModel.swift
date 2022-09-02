//
//  GNBProductViewModel.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import Foundation

class GNBProductViewModel {
    
    var products = [GNBProduct]()
    
    init(gnbTransaction: [GNBTransaction]?) {
        self.buildProducts(gnbTransaction: gnbTransaction)
    }
    
    private func buildProducts(gnbTransaction: [GNBTransaction]?) {
        if let gnbTransaction = gnbTransaction {
            
            var tuple = [String: [GNBTransaction]]()
            
            for transaction in gnbTransaction {
                let sku = transaction.sku
                if let _ = tuple[sku] {
                    tuple[sku]!.append(transaction)
                } else {
                    tuple[sku] = [transaction]
                }
            }
            
            for transaction in tuple {
                let key = transaction.key
                let value = transaction.value
                let product = GNBProduct(sku: key, transactions: value)
                products.append(product)
            }
        }
        
        print(products)
    }
}
