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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
