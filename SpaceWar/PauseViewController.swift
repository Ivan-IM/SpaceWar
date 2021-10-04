//
//  PauseViewController.swift
//  SpaceWar
//
//  Created by Иван Маришин on 03.10.2021.
//

import UIKit

protocol PauseVCDelegate {
    func pauseVCPlayButton(_ viewController: PauseViewController)
}

class PauseViewController: UIViewController {
    
    var delegate: PauseVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func PlayButton(_ sender: UIButton) {
        delegate.pauseVCPlayButton(self)
    }
    @IBAction func OptionButton(_ sender: UIButton) {
    }
    @IBAction func ShopButton(_ sender: UIButton) {
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
