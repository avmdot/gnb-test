//
//  GNBProductListView.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 1/9/22.
//

import SwiftUI

struct GNBProductListView: View {
    
    @ObservedObject var gnbTransactionViewModel : GNBTransactionViewModel
    
    init() {
        self.gnbTransactionViewModel = GNBTransactionViewModel()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20)  {
                    if let gnbProductViewModel = gnbTransactionViewModel.gnbProductViewModel {
                        ForEach(gnbProductViewModel.products, id: \.self) { product in
                            GNBProductElementView(product: product)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle(Text("Product List"))
            .onAppear {
                gnbTransactionViewModel.load()
            }
        }
    }
}
