//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Chase McElroy on 5/5/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController, let identifier = segue.identifier,
            let expression = emotionalFaces[identifier] {
            faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        
        }
    }
    
    private let emotionalFaces: Dictionary<String,FacialExpression> = [
        "sad" : FacialExpression(eyes: .closed, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, mouth: .smirk)
    ]

}