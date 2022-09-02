//
//  GNBProduct.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import Foundation

struct GNBProduct: Hashable, Equatable {
    
    let sku: String
    let transactions: [GNBTransaction]
    
    init(sku: String, transactions: [GNBTransaction]) {
        self.sku = sku
        self.transactions = transactions
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(sku)
    }
    
    // Equatable
    static func == (lhs: GNBProduct, rhs: GNBProduct) -> Bool {
        return lhs.sku == rhs.sku
    }
}
