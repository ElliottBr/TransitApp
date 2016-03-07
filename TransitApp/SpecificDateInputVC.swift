//
//  SpecificDateVC.swift
//  SpecificPicker
//
//  Created by Elliott Brunet on 05/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit

protocol SpecificDateDelegate {
    func goBackToDateView()
    func userHasSetSpecificDate(date: String)
}

class SpecificDateInputVC: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.datePickerMode = UIDatePickerMode.Date
            datePicker.minimumDate = NSDate()
        }
    }
    
    //MARK: - Actions
    
    @IBAction func savePressed(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        delegate?.userHasSetSpecificDate("\(strDate)")
    }
    
    @IBAction func backPressed(sender: UIButton) {
        delegate?.goBackToDateView()
    }
    
    //MARK: - Properties
    
    var delegate : SpecificDateDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
