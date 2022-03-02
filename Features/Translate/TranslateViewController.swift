//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 01/02/2022.
//

import UIKit

class TranslateViewController: UIViewController {

   
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var translatedLabel: UILabel!
    
    @IBOutlet weak var FlagImage: UIButton!
    
    let  translateRepository = TranslateRepository()
    // Utiliser une variable repository (TranslateRepository) qui s'occupe de faire la requete
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var TargetLang = "en"
    @IBAction func ChangeTarget(_ sender: UIButton) {
        if TargetLang == "fr"
        { sender.setImage(UIImage(named: "en.png"), for: .normal)
            TargetLang = "en"
        }
        else {sender.setImage(UIImage(named: "fr.png"), for: .normal)
            TargetLang = "fr"
        }
       }
    
    @IBAction func TranslateBtn(_ sender: UIButton) {
        let language : String = ""
        
        translateRepository.detectLangage(forText: inputTextView.text) { [self] language in
            DispatchQueue.main.async {
                let alertVC = UIAlertController(title: "Translation", message: "The sentence is in \(String(describing: languageDic[language!]!)) Language", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            }
        }
        
        translateRepository.translate(textToTranslate: inputTextView.text, fromLanguage: language ,toLanguage:TargetLang,  completion: { (textToTranslate) in
            DispatchQueue.main.async {
                self.translatedLabel.text = textToTranslate!
            }
         })
    }
}
