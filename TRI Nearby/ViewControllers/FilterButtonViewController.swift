//
//  FilterButtonViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/18/21.
//
import UIKit
class FilterButtonViewController: UIViewController {
    
    let sectorsStringArray = SectorsEnum.stringArray
    let releaseTypesStringArray = ReleaseTypesEnum.stringArray
    
    @IBOutlet weak var radiusSliderLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusSliderValueLabel: UILabel!
    @IBOutlet weak var filterSectorPickerView: UIPickerView!
    @IBOutlet weak var releaseTypeSectorPickerView: UIPickerView!
    
    @IBAction func closeFormView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func radiusSliderValueChanged(_ sender: Any) {
        let val = String(Int(radiusSlider.value.rounded()))
        radiusSliderValueLabel.text = "\(val) Miles"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        filterSectorPickerView.delegate = self
        filterSectorPickerView.dataSource = self
        filterSectorPickerView.tag = 1
        releaseTypeSectorPickerView.delegate = self
        releaseTypeSectorPickerView.dataSource = self
        releaseTypeSectorPickerView.tag = 2
        
    }
}

extension FilterButtonViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(component)
        var out:Int = 0
        if pickerView.tag == 1 {
            out = sectorsStringArray.count
        } else if pickerView.tag == 2 {
            out = releaseTypesStringArray.count
        }
        return out
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var out:String? = ""
        if pickerView.tag == 1 {
            out = sectorsStringArray[row]
        } else if pickerView.tag == 2 {
            out = releaseTypesStringArray[row]
        }
        return out
    }
}
