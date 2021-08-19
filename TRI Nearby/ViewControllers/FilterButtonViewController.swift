//
//  FilterButtonViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/18/21.
//
import UIKit
import CoreLocation

class FilterButtonViewController: UIViewController {
    
    // this controller allows the user to select filters for the search
    
    // MARK: Declare Constants
    let sectorsStringArray = SectorsEnum.stringArray
    let releaseTypesStringArray = ReleaseTypesEnum.stringArray
    
    //MARK: UI element outlet connections
    @IBOutlet weak var radiusSliderLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusSliderValueLabel: UILabel!
    @IBOutlet weak var filterSectorPickerView: UIPickerView!
    @IBOutlet weak var releaseTypeSectorPickerView: UIPickerView!
    @IBOutlet weak var carcinogenSwitch: UISwitch!
    
    //MARK:  UI element functionalities
    @IBAction func applyFilters(_ sender: Any) {
        // captures input values
        // TODO: use this to build a query and update user view
        let radius = Int(radiusSlider.value)
        print(radius)
        let sectorRow = filterSectorPickerView.selectedRow(inComponent: 0)
        print(sectorsStringArray[sectorRow])
        let releaseTypeRow = releaseTypeSectorPickerView.selectedRow(inComponent: 0)
        print(releaseTypesStringArray[releaseTypeRow])
        print(carcinogenSwitch.isOn)
        
    }
    @IBAction func clearFilters(_ sender: Any) {
        
        radiusSlider.setValue(5, animated: true)
        filterSectorPickerView.selectRow(0, inComponent: 0, animated: true)
        releaseTypeSectorPickerView.selectRow(0, inComponent: 0, animated: true)
        carcinogenSwitch.setOn(false, animated: true)
        radiusSliderValueLabel.text = "5 Miles"
    }
    
    @IBAction func closeFormView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func radiusSliderValueChanged(_ sender: Any) {
        let val = String(Int(radiusSlider.value.rounded()))
        radiusSliderValueLabel.text = "\(val) Miles"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radiusSlider.setValue(5, animated: true)
      
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, forComponent component: Int) -> String? {
        var out:String? = ""
        if pickerView.tag == 1 {
            return sectorsStringArray[row]
        } else if pickerView.tag == 2 {
            return releaseTypesStringArray[row]
        }
        return out
    }
    
}