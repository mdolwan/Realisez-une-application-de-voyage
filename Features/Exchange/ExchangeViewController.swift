//
//  exchangeViewController.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 01/02/2022.
//

import UIKit

class ExchangeViewController: UIViewController, UITextFieldDelegate {
    
    let repository = ExchangeRepository()
    
    @IBOutlet weak var inputEuroTextField: UITextField!
    @IBOutlet weak var getDollarLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputEuroTextField.keyboardType = UIKeyboardType.decimalPad
        inputEuroTextField.returnKeyType = .done
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    var exchangeTo = "$"
    @IBAction func swapExchange(_ sender: UIButton) {
        if exchangeTo == "$"
        { sender.setImage(UIImage(named: "euro.png"), for: .normal)
            exchangeTo = "€"
        }
        else {sender.setImage(UIImage(named: "us.png"), for: .normal)
            exchangeTo = "$"
        }
    }
    @IBAction func exchangeCurrency(_ sender: UIButton) {
        guard let text = inputEuroTextField.text,
              let euroAmount = Double(text) else {
                  return
              }
        repository.convertToDollar(amount: euroAmount, ToExchange: exchangeTo, completion: { convertedAmount in
           DispatchQueue.main.async {
               self.getDollarLabel.text = convertedAmount
           }
        })
        view.endEditing(true)
    }
}
