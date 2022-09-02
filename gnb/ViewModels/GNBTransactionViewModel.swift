//
//  GNBTransactionViewModel.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import Foundation

class GNBTransactionViewModel: ObservableObject {
    
    var gnbProductViewModel: GNBProductViewModel?
    
    var gnbTransaction: [GNBTransaction]?
    
    enum GNBTransactionState {
        case loading
        case error
        case loaded
    }

    @Published private(set) var state = GNBTransactionState.loading
    
    init() {
    }

    func load() {
        guard let gnbEngine = GNBEngine(url: GNBConstants.TRANSACTION_URL) else { return }
        gnbEngine.downloadTransactions { (gnbTransaction) in
            DispatchQueue.main.async {
                if let gnbTransaction = gnbTransaction {
                    self.gnbTransaction = gnbTransaction
                    
                    // Build Products
                    self.gnbProductViewModel = GNBProductViewModel(gnbTransaction: self.gnbTransaction)
                    
                    self.state = .loaded
                } else {
                    self.state = .error
                }
            }
        }
    }
}
