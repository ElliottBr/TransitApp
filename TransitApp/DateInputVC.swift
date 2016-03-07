//
//  DateInputeVC.swift
//  SpecificPicker
//
//  Created by Elliott Brunet on 05/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit
//Responsible for the date picker
protocol DateInputVCDelegate {
    func dismissDatePicker()
    func hasSetDate(date: String)
}

class DateInputVC: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var timePicker: UIDatePicker! {
        didSet {
            timePicker.datePickerMode = UIDatePickerMode.DateAndTime
            timePicker.minimumDate = NSDate()
        }
    }
    
    //MARK: - Actions
    
    @IBAction func savePressed(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let strTime = dateFormatter.stringFromDate(timePicker.date)
        delegate?.hasSetDate("\(strTime)")
    }
    
    @IBAction func nowPressed(sender: UIButton) {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        delegate?.hasSetDate("\(timestamp)")
    }
    
    @IBAction func DonePressed(sender: UIButton) {
        let strDate = dateFormatter.stringFromDate(timePicker.date)
        delegate?.hasSetDate("\(strDate)")
        delegate?.dismissDatePicker()
    }
    
    @IBAction func backPressed(sender: UIButton) {
        delegate?.dismissDatePicker()
    }
    
    //MARK: - Properties
    
    let dateFormatter = NSDateFormatter()
    var delegate: DateInputVCDelegate?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
