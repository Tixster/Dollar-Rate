//
//  Parser.swift
//  DollarRate
//
//  Created by Кирилл Тила on 24.06.2021.
//

import Foundation

class Parser: NSObject, XMLParserDelegate {
    
    private var items: [Rate] = []
    private var currentElement = ""
    private var currentValue = "" {
        didSet {
            currentValue = currentValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentDate = "" {
        didSet {
            currentDate = currentDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([Rate]) -> Void)?
    
    func parseRate(completion: @escaping (([Rate]) -> Void)){
        parserCompletionHandler = completion
        
        let url = URL(string: "http://cbr.ru/scripts/XML_dynamic.asp?date_req1=\(FetchDate.shared.dateOfBeginning())&date_req2=\(FetchDate.shared.currentDate())&VAL_NM_RQ=R01235")
        let request = URLRequest(url: url!)
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()

        }

        task.resume()

        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "Record" {
            
            currentValue = ""
            
            if let date = attributeDict["Date"] {
                currentDate = date
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "Value": currentValue += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Record" {
            let currentItem = Rate(date: currentDate, value: currentValue)
            items.append(currentItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(items)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
