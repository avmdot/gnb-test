//
//  GNBProductDetailView.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import SwiftUI

struct GNBProductDetailView: View {
    
    @ObservedObject var gnbRateViewModel : GNBRateViewModel
    
    let product: GNBProduct
    
    init(product: GNBProduct, gnbRateViewModel: GNBRateViewModel) {
        self.product = product
        self.gnbRateViewModel = gnbRateViewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20)  {
                Text("Total: " + String(gnbRateViewModel.gnbOperationViewModel?.total ?? 0)  + " €")
                
                ForEach(product.transactions.indices, id: \.self) { index in
                    let transaction = product.transactions[index]
                    HStack {
                        let cantidad = gnbRateViewModel.gnbOperationViewModel?.getEURAmount(value: Double(transaction.amount) ?? 0, currency: transaction.currency, checkeds: []) ?? 0
                        Text("Transaction " + String(index) + ": " + String(cantidad) + " €")
                    }
                }
            }
        }
        .padding()
        .navigationTitle(Text(product.sku))
    }
}
