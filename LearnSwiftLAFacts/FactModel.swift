//
//  FactModel.swift
//  LearnSwiftLAFacts
//
//  Created by Alistair Cooper on 10/9/16.
//  Copyright © 2016 Alistair Cooper. All rights reserved.
//

import Foundation
import GameKit

class FactModel {
    
    let jsonURL = "https://s3-us-west-2.amazonaws.com/awslearnswiftla/SwiftFacts.json"
    
    var swiftFacts: [String]?
    
    func downloadFacts(completion: @escaping (_ factArray: [String]?) -> Void) {
        
        guard let url = URL(string: jsonURL) else {
            print("Error with json url")
            return
        }
        
        URLSession.shared.dataTask(with:url, completionHandler: { (data, response, error) in
            
            guard let data = data, error == nil else {
                print(error)
                return
            }
            
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String] {
                    
                    self.swiftFacts = array
                    completion(array)
                }
                
            } catch let error as NSError {
                print(error)
            }
            
        }).resume()
    }
    
    func getRandomFact() -> String? {
        
        guard let factArray = swiftFacts else { return nil }
        
        let rand = GKRandomSource.sharedRandom().nextInt(upperBound: factArray.count)
        
        return factArray[rand]
    }
}
