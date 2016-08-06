//
//  MapDiscountDetailViewController.swift
//  Melmel
//
//  Created by Work on 1/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class MapDiscountDetailViewController: UIViewController {
    
    var viewTintColor:UIColor?

    @IBOutlet weak var discountTypeImgView: UIImageView!
    
    @IBOutlet weak var discountTagLabel: UILabel!
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var detailButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupView(){
        self.view.layer.shadowOpacity = 1.0
        self.view.layer.shadowRadius = 13.0
        self.view.layer.shadowOffset = CGSizeMake(0.0, -2.0)
        self.view.layer.shadowColor = UIColor(red: 242.0/255.0, green: 109.0/255.0, blue: 125.0/255.0, alpha: 1.0).CGColor
        //self.view.backgroundColor = UIColor(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.detailButton.backgroundColor = UIColor(red: 242.0/255.0, green: 109.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    }

}
