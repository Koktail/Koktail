//
//  HeaderTableViewCell.swift
//  xib_result
//
//  Created by 형주 on 2021/07/16.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerBar: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setFirstLabel()
        setSecondLabel()
    }
    
    func setFirstLabel() {
        switch base {
        case "liqueur":
            self.firstLabel.text! += "리큐르"
        case "vodka":
            self.firstLabel.text! += "보드카"
        case "gin":
            self.firstLabel.text! += "진"
        case "rum":
            self.firstLabel.text! += "럼"
        case "wisky":
            self.firstLabel.text! += "위스키"
        case "tequila":
            self.firstLabel.text! += "데낄라"
        default:
            self.firstLabel.text = ""
        }
        
        switch alcohol {
        case "LOW":
            self.firstLabel.text! += ",논 알콜"
        case "MID":
            self.firstLabel.text! += ",적당한 도수"
        case "HIGH":
            self.firstLabel.text! += ",높은 도수"
        default:
            self.firstLabel.text = ""
        }
        
        switch sweet {
        case "LOW":
            self.firstLabel.text! += ",달지 않은"
        case "MID":
            self.firstLabel.text! += ",달달한"
        case "HIGH":
            self.firstLabel.text! += ",더 달게"
        default:
            self.firstLabel.text = ""
        }
    }
    
    func setSecondLabel() {
        switch sour {
        case "LOW":
            self.secondLabel.text! += "시지 않은"
        case "MID":
            self.secondLabel.text! += "시게"
        case "HIGH":
            self.secondLabel.text! += "더 시게"
        default:
            self.secondLabel.text = ""
        }
        
        switch bitter {
        case "LOW":
            self.secondLabel.text! += ",쓰지 않은"
        case "MID":
            self.secondLabel.text! += ",쓰게"
        case "HIGH":
            self.secondLabel.text! += ",더 쓰게"
        default:
            self.secondLabel.text = ""
        }
        
        switch dry {
        case "LOW":
            self.secondLabel.text! += ""
        case "MID":
            self.secondLabel.text! += ",드라이한"
        case "HIGH":
            self.secondLabel.text! += ",더 드라이한"
        default:
            self.secondLabel.text = ""
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
