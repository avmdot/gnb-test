//
//  GNBTransaction.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import Foundation

class GNBTransaction: Decodable {
    
    let sku: String
    let amount: String
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case sku
        case amount
        case currency
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        sku = try container.decode(String.self, forKey: .sku)
        amount = try container.decode(String.self, forKey: .amount)
        currency = try container.decode(String.self, forKey: .currency)
    }
}
