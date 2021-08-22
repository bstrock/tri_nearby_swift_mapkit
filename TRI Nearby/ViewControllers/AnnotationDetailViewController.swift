//
//  AnnotationViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/17/21.
//

import Foundation
import UIKit

class AnnotationDetailViewController: UIViewController {
    // placeholders
    var annotation: SiteAnnotation!
    var secondarySelection: String?  // placeholder

    // buttons
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
        // handles selection of report type selection

        // change secondary segment display values based on report type selection
        if sender.selectedSegmentIndex == 0 {
            // active report
            secondaryTypeLabel.text = "Activity Type"
            secondarySegment.setTitle("Sitework", forSegmentAt: 0)
            secondarySegment.setTitle("Manufacturing", forSegmentAt: 1)
            secondarySegment.setTitle("Logistics", forSegmentAt: 2)
            reportTypeDescriptionTextBox.text = "Report observed activity at site"

        } else {
            // inactive report
            secondaryTypeLabel.text = "Inactivity Type"
            secondarySegment.setTitle("Signage", forSegmentAt: 0)
            secondarySegment.setTitle("Abandonment", forSegmentAt: 1)
            secondarySegment.setTitle("Disrepair", forSegmentAt: 2)
            reportTypeDescriptionTextBox.text = "Report evidence of an inactive site"

        }

        // reveal hidden elements in response to user selection
        secondaryTypeLabel.isHidden = false
        secondarySegment.isHidden = false
        reportTypeDescriptionTextBox.isHidden = false
    }

    @IBAction func secondaryTypeWasSelected(_ sender: UISegmentedControl) {

        // this switch changes the text shown under the secondary report type box based on what the user chose
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

            // required default cases
        case .none:
            secondaryTypeDescriptionTextBox.text = "error"
        case .some(_):
            secondaryTypeDescriptionTextBox.text = "error"
        }

        secondarySelection = sender.titleForSegment(at: sender.selectedSegmentIndex)  // store secondary selection

        // enable submit button and reveal hidden elements to allow user progress
        secondaryTypeDescriptionTextBox.isHidden = false
        submitReportButton.isEnabled = true
        messageTextField.isHidden = false
        messageTextField.placeholder = "(Optional)"
        messageLabel.isHidden = false
    }

    @IBAction func submitReport(_ sender: Any) {
        // they clicked submit, what happens next?

        // siteId and reportType required to instantiate the report objet
        let siteId = annotation.site.siteId
        let reportType = reportTypeSegment.titleForSegment(at: reportTypeSegment.selectedSegmentIndex)!

        var report = Report(
                reportId: nil,
                siteId: siteId,
                reportType: reportType,
                message: nil,
                emissionType: nil,
                activityType: nil,
                unusuedType: nil
        )

        // evaluate where to assign the secondary selection based on report type
        switch reportType {
        case "Active Site": report.activityType = secondarySelection!
        case "Inactive Site": report.unusuedType = secondarySelection!
        default:
            print("Something went wrong")
        }

        // capture message text, if any
        if messageTextField.hasText {
            report.message = messageTextField.text
        }

        // report parameters complete
        // send the report off to the API for db storage
        // TODO:  implement try/catch error handling here
        postReportJsonData(report: report) { (response) in

            // report was successful- confirm to user
            let alertMessage = "Thank you for submitting your Site Report! \n Your \(reportType) Report about \(self.secondarySelection!) at \(self.annotation.site.name) is Report # \(response.reportId!) submitted to TRI Nearby!"
            let ac = UIAlertController(title: "Report Submission Confirmed", message: alertMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.whenDone() }))  // dismisses modal after alert is acknowledged
            self.present(ac, animated: true, completion: nil)
        }
    }

    @IBAction func closeAnnotationDetail(_ sender: Any) {
        // called by "X" button
        dismiss(animated: true, completion: nil)
    }

    func whenDone() {
        // called when submission is complete
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {

        if let vc = presentingViewController as? ViewController {

            // basic view config- text values, segment selections, etc.
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
