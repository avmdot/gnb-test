//
//  GNBProductElementView.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import SwiftUI

struct GNBProductElementView: View {
    
    @ObservedObject var gnbRateViewModel : GNBRateViewModel
    
    let product: GNBProduct
    
    init(product: GNBProduct) {
        self.product = product
        self.gnbRateViewModel = GNBRateViewModel(product: product)
    }
    
    var body: some View {
        NavigationLink(destination: GNBProductDetailView(product: product, gnbRateViewModel: gnbRateViewModel)) {
            Text(product.sku)
        }
        .onAppear {
            gnbRateViewModel.load()
        }
    }
}
