//
//  WelcomeViewController.swift
//  NoteApp
//
//  Created by Pj Nguyen on 2/8/17.
//  Copyright © 2017 Pj Nguyen. All rights reserved.
//

import UIKit
import PulsingHalo

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initHalo()
    }

    func initHalo() {
        let halo = PulsingHaloLayer()
        halo.haloLayerNumber = 2
        halo.radius = self.view.frame.width / 2
        halo.backgroundColor = UIColor.white.cgColor
        halo.position = view.center
        view.layer.addSublayer(halo)
        halo.start()
    }
    
    @IBAction func noteDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "welcomeSegue", sender: nil)

    }
    

}
