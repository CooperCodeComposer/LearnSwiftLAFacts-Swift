//
//  ViewController.swift
//  LearnSwiftLAFacts
//
//  Created by Alistair Cooper on 10/9/16.
//  Copyright © 2016 Alistair Cooper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties 
    
    let imageURL = "https://s3-us-west-2.amazonaws.com/awslearnswiftla/LSLAclouds.jpg"
    
    // creating an instance of the FactModel object
    var factModel = FactModel()
    
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
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error)
                return
            }
            
            DispatchQueue.main.sync() {
                self.headerImageView.contentMode = .scaleAspectFill
                self.headerImageView.image = UIImage(data: data)
                self.activityIndicator.stopAnimating()
            }
        }
            
        task.resume()
    }
    
    func downloadJson() {
        
        factModel.downloadFacts() { (factArray) in
            
            guard let factArray = factArray else {
                print("Error with factArray")
                return
            }
            
            // set data model
            self.factModel.swiftFacts = factArray
            
            DispatchQueue.main.sync() {
                self.factsLabel.text = self.factModel.getRandomFact()
                self.nextFactButton.isEnabled = true
            }
        }
    }
    
    // MARK: IBActions
    
    @IBAction func nextFact(_ sender: UIButton) {
        
        factsLabel.text = factModel.getRandomFact()
    }
    

}

