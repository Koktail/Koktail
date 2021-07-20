//
//  SelectBaseViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/17.
//

import UIKit

class SelectBaseViewController: UIViewController {
    @IBOutlet weak var nullBaseButton: SelectButton!
    @IBOutlet weak var VodkaBaseButton: SelectButton!
    @IBOutlet weak var GinBaseButton: SelectButton!
    @IBOutlet weak var RumBaseButton: SelectButton!
    @IBOutlet weak var WiskyBaseButton: SelectButton!
    @IBOutlet weak var TequilaBaseButton: SelectButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        for recognizer in UIViewController.recog{
//            recognizer.isEnabled = false
//        }
        
//        self.navigationController?.gest
    }
   
    @IBAction func nonBtnPress(_ sender: Any) {
        pv!.goToNextPage()
    }
    
    @IBAction func VodkaBtnPress(_ sender: Any) {
        pv!.goToNextPage()
    }
    
    @IBAction func GinBtnPress(_ sender: Any) {
        pv!.goToNextPage()
    }
    
    @IBAction func RumBtnPress(_ sender: Any) {
        pv!.goToNextPage()
    }
    
    @IBAction func WiskyBtnPress(_ sender: Any) {
        pv!.goToNextPage()
    }
    
    @IBAction func TequilaBtnPress(_ sender: Any) {
        pv!.goToNextPage()
    }
    
    @IBAction func prevButton(_ sender: Any) {
//        pv!.goToPreviousPage()
        self.navigationController?.popViewController(animated: true)
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
// MARK: - 버튼 클래스
class SelectButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
        self.setTitleColor(UIColor.black, for: .normal)
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
        self.layer.frame.size.height = self.layer.frame.width
        }
}
class SelectLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        
        self.font = .boldSystemFont(ofSize: 18)
        }
}

class PgControll: UIPageControl {
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        
        self.currentPageIndicatorTintColor = UIColor(red: 199.0/255.0, green: 116.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        self.pageIndicatorTintColor = .systemGray
        }
}

class PreviousButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
//        self.frame.size.width = UIScreen.main.bounds.width * 0.2
//        self.frame.size.height = UIScreen.main.bounds.width * 0.2
        self.backgroundColor = UIColor(red: 199/255, green: 116/255, blue: 104/255, alpha: 1)
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 15
        self.setTitle(" < prev ", for: UIControl.State.normal)
//        self.layer.frame.size.height =
        self.layer.frame.size.width = 200
        }
}
