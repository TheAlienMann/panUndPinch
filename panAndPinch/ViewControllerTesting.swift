//
//  ViewController.swift
//  panAndPinch
//
//  Created by imedev4 on 24/04/2019.
//  Copyright © 2019 5W2H. All rights reserved.
//

import UIKit

class ViewControllerTesting: UIViewController {
    
    var pinch = UIPinchGestureRecognizer()
    var pan = UIPanGestureRecognizer()
    var backgroundImageView = UIImageView()
    var foregroundImageView:UIImageView!
    var container = UIView()
    var topContainer = UIView()
    
    var initialFrame = CGRect.zero
    
    
    // MARK: - Testing Properties
    var toolsPanelView = UIView()
    var penButton = UIButton()
    var penView = UIView()
    var penViewPanGeture = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.isNavigationBarHidden = true
        

        navigationController!.view.addSubview(toolsPanelView)
//        view.addSubview(toolsPanelView)
        toolsPanelView.leftToSuperview()
        toolsPanelView.rightToSuperview()
        toolsPanelView.bottomToSuperview()
        toolsPanelView.height(100)
        toolsPanelView.backgroundColor = .white
        
        
        view.addSubview(container)
//        container.bottomToTop(of: toolsPanelView)
        container.bottomToSuperview(nil, offset: -100, relation: .equal, priority: .required, isActive: true, usingSafeArea: true)
        container.topToSuperview()
        container.rightToSuperview()
        container.leftToSuperview()
        
        
        
        
        
        container.addSubview(backgroundImageView)
        backgroundImageView.center(in: container)
        backgroundImageView.width(to: container)
        backgroundImageView.height(to: container)
        backgroundImageView.image = UIImage(named: "4k")

        container.addSubview(topContainer)
        topContainer.height(300)
        topContainer.width(300)
        topContainer.centerInSuperview()

        
        //background image
        foregroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        foregroundImageView.image = UIImage(named: "rose")
        self.topContainer.addSubview(foregroundImageView)
        foregroundImageView.contentMode = .scaleAspectFit

        
        
        
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        topContainer.addGestureRecognizer(pinch)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        topContainer.addGestureRecognizer(pan)
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialFrame = foregroundImageView.frame
        
    }
    
    //MARK: Pinch
    @objc func didPinch(_ pinch: UIPinchGestureRecognizer) {
        if pinch.state != .changed {
            return
        }
        let scale = pinch.scale
        let location = pinch.location(in: topContainer)
        let scaleTransform = foregroundImageView.transform.scaledBy(x: scale, y: scale)
        foregroundImageView.transform = scaleTransform
        
        let dx = foregroundImageView.frame.midX - location.x
        let dy = foregroundImageView.frame.midY - location.y
        let x = dx * scale - dx
        let y = dy * scale - dy
        
        
        let translationTransform = CGAffineTransform(translationX: x, y: y)
        foregroundImageView.transform = foregroundImageView.transform.concatenating(translationTransform)
        
        pinch.scale = 1
    }
    
    
    //MARK: - pan ( move the view even if you zoomed to much)
    @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state != .changed {
            return
        }
        
        let scale = foregroundImageView.frame.size.width / initialFrame.size.width
        let translation = recognizer.translation(in: topContainer)
        let transform = foregroundImageView.transform.translatedBy(x: translation.x / scale, y: translation.y / scale)
        foregroundImageView.transform = transform
        recognizer.setTranslation(.zero, in: topContainer)
    }
    

}

extension ViewControllerTesting {
    
    func setupUI() {
        toolsPanelView.addSubview(penButton)
        penButton.center(in: toolsPanelView)
        penButton.width(200)
        penButton.height(63)
        penButton.setTitle("Pen to Draw", for: .normal)
        penButton.setTitleColor(.black, for: .normal)
        penButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        penButton.layer.borderWidth = 0.5
        penButton.layer.borderColor = UIColor.lightGray.cgColor
        penButton.addTarget(self, action: #selector(addPenView), for: .touchUpInside)
    }
    
    @objc func addPenView() {
        topContainer.removeGestureRecognizer(pan)
        topContainer.removeGestureRecognizer(pinch)
        print(#line, #file.components(separatedBy: "/").last!, "pan & pinch got removed!")
        topContainer.addSubview(penView)
        penView.centerInSuperview()
        penView.width(50)
        penView.height(50)
        penView.backgroundColor = .orange
        
        penViewPanGeture = UIPanGestureRecognizer(target: self, action: #selector(penViewPanHandle))
        penView.addGestureRecognizer(penViewPanGeture)
    }
    
    
    @objc func penViewPanHandle(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .changed {
            
            let translation = recognizer.translation(in: penView)
            let transform = penView.transform.translatedBy(x: translation.x, y: translation.y)
            penView.transform = transform
            recognizer.setTranslation(.zero, in: penView)
        }
        else if recognizer.state == .ended {
            topContainer.removeGestureRecognizer(penViewPanGeture)
            print(#line, #file.components(separatedBy: "/").last!, "penViewPanGeture got removed!")
            topContainer.addGestureRecognizer(pan)
            topContainer.addGestureRecognizer(pinch)
            print(#line, #file.components(separatedBy: "/").last!, "pan & pinch gestures got added!")
            penView.removeFromSuperview()
        }
    }
}

