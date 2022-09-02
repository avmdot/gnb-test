//
//  GNBOperationViewModel.swift
//  gnb
//
//  Created by Alejandro Vicente Milán on 2/9/22.
//

import Foundation

class GNBOperationViewModel {
    
    var eurArray = [String]()
    
    var gnbRate: [GNBRate]?
    
    var total:Double = 0.0
    
    init(gnbRate: [GNBRate]?, product: GNBProduct?) {
        self.gnbRate = gnbRate
        self.initEUR(gnbRate: gnbRate)
        self.calculateTotal(product: product)
    }
    
    private func initEUR(gnbRate: [GNBRate]?) {
        if let gnbRate = gnbRate {
            for item in gnbRate {

                let value = ((Double(item.rate) ?? 0) * 100)
                item.rateRound = value

                if item.to == "EUR" {
                    eurArray.append(item.from)
                }
            }
        }
    }
    
    private func calculateTotal(product: GNBProduct?) {
        if let product = product {
            for transaction in product.transactions {
                let cantidad = getEURAmount(value: Double(transaction.amount) ?? 0, currency: transaction.currency, checkeds: [])
                self.total += cantidad
            }
            self.total = Double(round(100 * total) / 100)
        }
    }
    
    func getEURAmount(value: Double, currency: String, checkeds: [String]) -> Double {
        
        if eurArray.firstIndex(of: currency) != nil && eurArray.firstIndex(of: currency) != -1 {

            let rate = getRateItem(currency: currency, isEur: true, checkeds: nil)

            let valor = roundHalfToEven(value: (value * Double(rate?.rateRound ?? 0)) / 100)
            
            return valor

        } else {

            var checkeds = checkeds
            checkeds.append(currency)

            let rate = getRateItem(currency: currency, isEur: false, checkeds: checkeds)

            var value = value
            value = roundHalfToEven(value: (value * Double(rate?.rateRound ?? 0)) / 100)

            let valor = getEURAmount(value: value, currency: rate?.to ?? "EUR", checkeds: checkeds)
            
            return valor
        }
    }
    
    private func getRateItem(currency: String, isEur: Bool, checkeds: [String]?) -> GNBRate? {

        if let gnbRate = gnbRate {
            for item in gnbRate {
                
                if item.from == currency {
                    if(isEur && item.to == "EUR") {
                        return item
                    } else if checkeds?.firstIndex(of: item.to) != -1, !isEur {
                        return item
                    }
                }
            }
        }
        return nil
    }
    
    private func roundHalfToEven(value: Double) -> Double {

        let integerPart = Double(round(100 * value) / 100)
        let decimalPart = (value - integerPart) * 100

        if(decimalPart < 50) {
          return integerPart
        } else if(decimalPart > 50) {
          return integerPart + 1
        } else {
            if(integerPart.truncatingRemainder(dividingBy: 2) == 0) {
                return integerPart
            } else {
                return integerPart + 1
            }
        }
    }
}
