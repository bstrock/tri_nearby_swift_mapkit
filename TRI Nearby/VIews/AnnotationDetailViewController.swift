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
    
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        print("CLICK?")
    }
}
