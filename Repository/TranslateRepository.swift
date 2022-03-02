//
//  Translate.swift
//  Baluchon
//
//  Created by Mohammad Olwan on 01/02/2022.
//

import Foundation
class TranslateRepository {
    
    var sourceLanguageCode = "fr"
    var targetLanguageCode = "en"
    let apiKey = ""
    
    
    enum TranslationAPI {
        case detectLanguage
        case translate
        case supportedLanguages
        
        func getURL() -> String {
            var urlString = ""

            switch self {
            case .detectLanguage:
                urlString = "https://translation.googleapis.com/language/translate/v2/detect"
                
            case .translate:
                urlString = "https://translation.googleapis.com/language/translate/v2"
                
            case .supportedLanguages:
                urlString = "https://translation.googleapis.com/language/translate/v2/languages"
            }
            return urlString
        }
        func getHTTPMethod() -> String {
            if self == .supportedLanguages {
                return "GET"
            } else {
                return "POST"
            }
        }
    }
    
    var session = URLSession(configuration: .default)
    
    
    
    func translate(textToTranslate: String,fromLanguage: String,toLanguage: String, completion: @escaping (_ translations: String?) -> Void) {
        if toLanguage == "en"{
            targetLanguageCode = "en"
            sourceLanguageCode = fromLanguage
        } else {
             targetLanguageCode = "fr"
             sourceLanguageCode = fromLanguage
        }
        let textToTranslate = textToTranslate
        
        var urlParams = [String: String]()
        urlParams["key"] = apiKey
        urlParams["q"] = textToTranslate
        urlParams["target"] = targetLanguageCode
        urlParams["format"] = "text"
        urlParams["source"] = sourceLanguageCode
        
        makeRequest(usingTranslationAPI: .translate, urlParams: urlParams) { (results) in
            guard let results = results else { completion(nil); return }
            
            if let data = results["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] {
                var allTranslations = [String]()
                for translation in translations {
                    if let translatedText = translation["translatedText"] as? String {
                        allTranslations.append(translatedText)
                    }
                }
                if allTranslations.count > 0 {
                    completion(allTranslations[0])
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    func makeRequest(usingTranslationAPI api: TranslationAPI, urlParams: [String: String], completion: @escaping (_ results: [String: Any]?) -> Void) {
        
        guard let url = getURL(from: api, params: urlParams) else {
            completion([:])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.getHTTPMethod()
        
       
        let task = session.dataTask(with: request) { (results, response, error) in
            if let error = error {
                print(error)
                completion(nil)
            } else {
                if let response = response as? HTTPURLResponse, let results = results {
                    if response.statusCode == 200 || response.statusCode == 201 {
                        do {
                            if let resultsDict = try JSONSerialization.jsonObject(with: results, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] {
                                completion(resultsDict)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func getURL(from api: TranslationAPI, params: [String: String]) -> URL? {
        guard var components = URLComponents(string: api.getURL()) else {
            return nil
        }
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params.sorted(by: { $0.0 < $1.0 }) {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return components.url
    }
    
    func detectLangage(forText text: String, completion: @escaping (_ language: String?) -> Void) {
        let urlParams = ["key": apiKey, "q": text]
     
        makeRequest(usingTranslationAPI: .detectLanguage, urlParams: urlParams) { [self] (results) in
            guard let results = results else { completion(nil); return }
     
            if let data = results["data"] as? [String: Any], let detections = data["detections"] as? [[[String: Any]]] {
                var detectedLanguages = [String]()
             
                for detection in detections {
                    for currentDetection in detection {
                        if let language = currentDetection["language"] as? String {
                            detectedLanguages.append(language)
                        }
                    }
                }
                if detectedLanguages.count > 0 {
                    self.sourceLanguageCode = detectedLanguages[0]
                    completion(detectedLanguages[0])
                } else {
                    completion(nil)
                    return
                }
             
            } else {
                completion(nil)
            }
        }
    }
}

