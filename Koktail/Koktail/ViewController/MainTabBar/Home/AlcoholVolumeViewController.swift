//
//  AlcoholVolumeViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/04.
//

import UIKit

class AlcoholVolumeViewController: UIViewController {
    @IBOutlet weak var NonAlcoholButton: SelectButton!
    @IBOutlet weak var middleAlcoholButton: SelectButton!
    @IBOutlet weak var highAlcoholButton: SelectButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
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

class SelectButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        self.setTitleColor(UIColor.black, for: .normal)
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 3
        }
}
