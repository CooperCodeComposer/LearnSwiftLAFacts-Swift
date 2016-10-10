//
//  ViewController.swift
//  LearnSwiftLAFacts
//
//  Created by Alistair Cooper on 10/9/16.
//  Copyright © 2016 Alistair Cooper. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    
    // MARK: Properties 
    
    let imageURL = "https://s3-us-west-2.amazonaws.com/awslearnswiftla/LSLAclouds.jpg"
    let jsonURL = "https://s3-us-west-2.amazonaws.com/awslearnswiftla/SwiftFacts.json"
    
    var swiftFacts: [String]?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var factsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextFactButton: UIButton!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextFactButton.isEnabled = false
        
        activityIndicator.startAnimating()
        
        downloadImage()
        
        downloadJson()
        
    }

    func downloadImage() {
        
        // makes optional url
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error)
                return
            }
            
            DispatchQueue.main.sync {
                
                if let image = UIImage(data: data) {
                    self.headerImageView.contentMode = .scaleAspectFill

                    self.headerImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }.resume()
    }
    
    func downloadJson() {
        
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
                    
                    DispatchQueue.main.sync() {
                        self.factsLabel.text = self.getRandomFact()
                        self.nextFactButton.isEnabled = true
                    }
                    
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
    
    // MARK: IBActions
    
    @IBAction func nextFact(_ sender: UIButton) {
        
        factsLabel.text = getRandomFact()
    }
}

