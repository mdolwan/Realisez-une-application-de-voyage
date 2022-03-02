//
//  Exchange.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 01/02/2022.
//

import Foundation

class ExchangeRepository {
    
    private let baseUri: String = "http://data.fixer.io/api/latest?access_key=ba105d9879c0ba1c1554a1bfd2d65b54"

    private var amount: Double = 0
    
    lazy var url = URL(string: baseUri)
    
    var session = URLSession(configuration: .default)
    
    init() {}
    
    func convertToDollar(amount: Double, ToExchange: String, completion: @escaping (_ value: String) -> Void) {
        self.amount = amount
        
        let task = session.dataTask(with: url!, completionHandler: { [weak self] (data: Data?, urlresponse: URLResponse?, error: Error?) in
            guard let self = self, let data = data,
                  let dollarValue = try? JSONDecoder().decode(Dollar.self, from: data),
                  let dollarRates = dollarValue.rates["USD"] else {
                      completion("Une erreur est survenue")
                      return
                  }
            
            let convertedAmount: Double
            if ToExchange == "$" {
                convertedAmount = self.amount * dollarRates
            } else {
                convertedAmount = (self.amount / dollarRates)
            }
            let formatted = String(format: " %.2f", convertedAmount)
           
            let value = "\(formatted) \(ToExchange)"
            completion(value)
        })
        
        task.resume()
    }
}
