//
//  AnnotationViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/17/21.
//

import Foundation
import UIKit

class AnnotationDetailViewController: UIViewController {
    var annotation: SiteAnnotation!
    var secondarySelection: String?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var boilerplateTextBox: UILabel!
    @IBOutlet weak var reportTypeSegment: UISegmentedControl!
    @IBOutlet weak var siteNameLabel: UILabel!
    @IBOutlet weak var secondaryTypeLabel: UILabel!
    @IBOutlet weak var reportTypeDescriptionTextBox: UILabel!
    @IBOutlet weak var secondarySegment: UISegmentedControl!
    @IBOutlet weak var secondaryTypeDescriptionTextBox: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var submitReportButton: UIButton!
    
    @IBAction func reportTypeWasSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            secondaryTypeLabel.text = "Activity Type"
            secondarySegment.setTitle("Sitework", forSegmentAt: 0)
            secondarySegment.setTitle("Manufacturing", forSegmentAt: 1)
            secondarySegment.setTitle("Logistics", forSegmentAt: 2)
            reportTypeDescriptionTextBox.text = "Report observed activity at site"
            
        } else {
            secondaryTypeLabel.text = "Inactivity Type"
            secondarySegment.setTitle("Signage", forSegmentAt: 0)
            secondarySegment.setTitle("Abandonment", forSegmentAt: 1)
            secondarySegment.setTitle("Disrepair", forSegmentAt: 2)
            reportTypeDescriptionTextBox.text = "Report evidence of an inactive site"
            
        }
        secondaryTypeLabel.isHidden = false
        secondarySegment.isHidden = false
        reportTypeDescriptionTextBox.isHidden = false
    }
    
    @IBAction func secondaryTypeWasSelected(_ sender: UISegmentedControl) {
        switch sender.titleForSegment(at: sender.selectedSegmentIndex) {
        case "Sitework":
            secondaryTypeDescriptionTextBox.text = "Construction, renovation, etc."
        case "Manufacturing":
            secondaryTypeDescriptionTextBox.text = "Activity suggesting ongoing work"
        case "Logistics":
            secondaryTypeDescriptionTextBox.text = "Vehicles such as trucks, tankers, etc."
        case "Signage":
            secondaryTypeDescriptionTextBox.text = "Posted notice indicating inactivity"
        case "Abandonment":
            secondaryTypeDescriptionTextBox.text = "Clear indication of complete disuse"
        case "Disrepair":
            secondaryTypeDescriptionTextBox.text = "Major evidence of structural fatigue"
        case .none:
            secondaryTypeDescriptionTextBox.text = "error"
        case .some(_):
            secondaryTypeDescriptionTextBox.text = "error"
        }
        secondarySelection = sender.titleForSegment(at: sender.selectedSegmentIndex)
        secondaryTypeDescriptionTextBox.isHidden = false
        submitReportButton.isEnabled = true
        messageTextField.isHidden = false
        messageTextField.placeholder = "(Optional)"
        messageLabel.isHidden = false
            
    }
    @IBAction func submitReport(_ sender: Any) {

        let siteId = annotation.site.siteId
        let reportType = reportTypeSegment.titleForSegment(at: reportTypeSegment.selectedSegmentIndex)!
        
        var report = Report(reportId: nil,
                            siteId: siteId,
                            reportType: reportType,
                            message: nil,
                            emissionType: nil,
                            activityType: nil,
                            unusuedType: nil)
        print(reportType)
        switch reportType {
        case "Active Site": report.activityType = secondarySelection!
        case "Inactive Site": report.unusuedType = secondarySelection!
        default:
            print("Something went wrong")
        }
        
        if messageTextField.hasText {
            report.message = messageTextField.text
        }
        
        postReportJsonData(report: report) { (response) in
            
            let alertMessage = "Thank you for submitting your Site Report! \n Your \(reportType) Report about \(self.secondarySelection!) at \(self.annotation.site.name) is Report # \(response.reportId!) submitted to TRI Nearby!"
            let ac = UIAlertController(title: "Report Submission Confirmed", message: alertMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.whenDone()}))
            self.present(ac, animated: true, completion: nil)
        }
    }
        
    
    @IBAction func closeAnnotationDetail(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func whenDone(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        if let vc = presentingViewController as? ViewController {
            annotation = vc.selectedAnnotation
            siteNameLabel.text = annotation?.title
            reportTypeSegment.selectedSegmentIndex = UISegmentedControl.noSegment
            secondarySegment.selectedSegmentIndex = UISegmentedControl.noSegment
            
            reportTypeSegment.setTitle("Active Site", forSegmentAt: 0)
            reportTypeSegment.setTitle("Inactive Site", forSegmentAt: 1)

            boilerplateTextBox.text = "Use this form to help update the models used to generate environmental justice data by the app by reporting site activity or inactivity"
        }
    }
}
