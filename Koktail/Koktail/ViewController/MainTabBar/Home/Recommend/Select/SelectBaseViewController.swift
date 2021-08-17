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
    }
   
    @IBAction func nonBtnPress(_ sender: Any) {
        base = "liqueur"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.nullBaseButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func VodkaBtnPress(_ sender: Any) {
        base = "vodka"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.VodkaBaseButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func GinBtnPress(_ sender: Any) {
        base = "gin"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.GinBaseButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func RumBtnPress(_ sender: Any) {
        base = "rum"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.RumBaseButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func WiskyBtnPress(_ sender: Any) {
        base = "wisky"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.WiskyBaseButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func TequilaBtnPress(_ sender: Any) {
        base = "tequila"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.TequilaBaseButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func prevButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setButtonWhite() {
        self.nullBaseButton.backgroundColor = UIColor.white
        self.GinBaseButton.backgroundColor = UIColor.white
        self.RumBaseButton.backgroundColor = UIColor.white
        self.TequilaBaseButton.backgroundColor = UIColor.white
        self.WiskyBaseButton.backgroundColor = UIColor.white
        self.VodkaBaseButton.backgroundColor = UIColor.white
    }
    
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
        
        self.currentPageIndicatorTintColor =
            UIColor(red: 245/255, green: 98/255, blue: 90/255, alpha: 1.0)
        self.pageIndicatorTintColor = .systemGray
        }
}

class PreviousButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 245/255, green: 98/255, blue: 90/255, alpha: 1.0)
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 15
        self.setTitle(" < prev ", for: UIControl.State.normal)
        self.layer.frame.size.width = 200
        }
}
