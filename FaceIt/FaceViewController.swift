//
//  ViewController.swift
//  FaceIt
//
//  Created by Chase McElroy on 5/4/17.
//  Copyright © 2017 Chase McElroy. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer (target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byRactingTo:)))
//            tapRecognizer.numberOfTapsRequired = 1
//            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappieness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(deacreaseHappieness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }
    
    private struct HeadShake {
        static let angle = CGFloat.pi/6                 //radians
        static let segmentDuration: TimeInterval = 0.5  // each head shake has 3 segments
    }
    
    private func rotateFace(by angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead() {
        UIView.animate(
            withDuration: HeadShake.segmentDuration,
            animations: {
                self.rotateFace(by: HeadShake.angle)
        }) { finished in
            if finished {
                UIView.animate(
                    withDuration: HeadShake.segmentDuration,
                    animations: {
                        self.rotateFace(by: -HeadShake.angle*2)
                },
                    completion: { finished in
                        UIView.animate(
                            withDuration: HeadShake.segmentDuration,
                            animations: {
                                self.rotateFace(by: HeadShake.angle)
                        })
                })
            }
        }
    }
    @IBAction func shakeHead(_ sender: UITapGestureRecognizer) {
        shakeHead()
    }
    
    func increaseHappieness() {
        expression = expression.happier
    }
    func deacreaseHappieness() {
        expression = expression.sadder
    }
    
    func toggleEyes(byRactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .frown) {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
            
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ??  0.0
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin:0.5,.frown:-1.0,.smile:1.0,.neutral:0.0,.smirk:-0.5]
    
    
}

