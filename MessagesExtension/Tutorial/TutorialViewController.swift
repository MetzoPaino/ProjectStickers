//
//  TutorialViewController.swift
//  projectstickers
//
//  Created by William Robinson on 06/11/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit

protocol TutorialViewControllerDelegate: class {
    func quitButtonPressed()
}

class TutorialViewController: UIViewController {

    weak var delegate: TutorialViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        
        self.delegate?.quitButtonPressed()
    }
}
