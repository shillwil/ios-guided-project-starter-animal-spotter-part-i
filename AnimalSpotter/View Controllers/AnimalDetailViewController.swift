//
//  AnimalDetailViewController.swift
//  AnimalSpotter
//
//  Created by Alex Shillingford on 6/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalDetailViewController: UIViewController {
    
    @IBOutlet weak var timeSeenLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    
    var animalName: String?
    var apiController: APIController?

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        // Do any additional setup after loading the view.
    }
    
    func getDetails() {
        guard let apiController = apiController,
            let animalName = animalName else { return }
        
        apiController.fetchDetails(for: animalName) { result in
            if let animal = try? result.get() {
                DispatchQueue.main.async {
                    self.updateViews(with: animal)
                }
                // fetch details for animalImage
                apiController.fetchImage(at: animal.imageURL, completion: { result in
                    if let image = try? result.get() {
                        DispatchQueue.main.async {
                            self.animalImageView.image = image
                        }
                    }
                })
            }
        }
    }
    
    func updateViews(with animal: Animal) {
        descriptionLabel.text = animal.description
        coordinatesLabel.text = "lat: \(animal.latitude), long: \(animal.longitude)"
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        
        timeSeenLabel.text = df.string(from: animal.timeSeen)
    }
}
