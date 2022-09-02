//
//  GNBRate.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import Foundation

class GNBRate: Decodable {
    
    let from: String
    let to: String
    let rate: String
    
    var rateRound: Double?
    
    enum CodingKeys: String, CodingKey {
        case from
        case to
        case rate
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
        rate = try container.decode(String.self, forKey: .rate)
    }
}
