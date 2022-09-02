//
//  GNBRateViewModel.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import Foundation

class GNBRateViewModel: ObservableObject {
    
    var gnbOperationViewModel: GNBOperationViewModel?
    
    var gnbRate: [GNBRate]?
    
    var product: GNBProduct?
    
    enum GNBRateState {
        case loading
        case error
        case loaded
    }

    @Published private(set) var state = GNBRateState.loading
    
    init(product: GNBProduct?) {
        self.product = product
    }

    func load() {
        guard let gnbEngine = GNBEngine(url: GNBConstants.RATE_URL) else { return }
        gnbEngine.downloadRates { (gnbRate) in
            DispatchQueue.main.async {
                if let gnbRate = gnbRate {
                    self.gnbRate = gnbRate
                    
                    // Build Operations
                    self.gnbOperationViewModel = GNBOperationViewModel(gnbRate: self.gnbRate, product: self.product)
                    
                    self.state = .loaded
                } else {
                    self.state = .error
                }
            }
        }
    }
}
