//
//  FilterButtonViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/18/21.
//
import UIKit
import CoreLocation
import MapKit

class FilterButtonViewController: UIViewController {
    
    // this controller allows the user to select filters for the search
    
    // MARK: Declare Constants
    
    let mapViewController:ViewController = ViewController()
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
        
        // this function captures the user's query input and displays the annotations:
        // 1. get values from selections
        // 2. call api with query from values
        // 3. unpack the response
        // 4. clear existing annotations and overlays
        // 5. display the updated annotations and overlay
        // 6. set the view size according to the overlay bounds
        if let vc = presentingViewController as? ViewController {
            // MARK: 1. captures input values
            
            // capture radius
            let radius = Int(radiusSlider.value)
            vc.filterParams["radius"] = radius  // persistent filter state assignemnt
            
            // capture sector (if selected)
            var sectors:String? = nil
            let sectorRow = filterSectorPickerView.selectedRow(inComponent: 0)
            if sectorRow > 0 {
                sectors = sectorsStringArray[sectorRow]
                vc.filterParams["sectors"] = sectorRow  // persistent filter state assignemnt
            }
            
            // capture release type (if selected)
            var releaseType:String? = nil
            let releaseTypeRow = releaseTypeSectorPickerView.selectedRow(inComponent: 0)
            if releaseTypeRow > 0 {
                releaseType = releaseTypesStringArray[releaseTypeRow].uppercased()
                vc.filterParams["releaseType"] = releaseTypeRow
            }
            
            // capture carcinogen swsitch (if selected)
            var carcinogen:Bool? = nil
            if carcinogenSwitch.isOn {
                carcinogen = true
                vc.filterParams["carcinogen"] = true
            }

            // MARK: here's where we use the main view controller to coordinate the transfer of query data to api to mapview
        
            let location:CLLocationCoordinate2D = vc.locationManager.location!.coordinate
            
            // MARK: 2. build the query from the filter values
            let query = Query(latitude: location.latitude,
                              longitude: location.longitude,
                              accessToken: "",
                              radius: radius,
                              releaseType: releaseType,
                              carcinogen: carcinogen,
                              sectors: sectors)
            
            // MARK: 3. translates the filter values into query strings and calls the api asyncronously
            fetchSitesJsonData(query: query) { (incomingSites) in
            
            // MARK: 4. clear existing annotations and overlays
            // TODO:  Recycle these assets correctly.  This is inefficient, but demonstrates proof of function/concept.
            
            vc.mapView.removeAnnotations(vc.mapView.annotations)
            vc.mapView.removeOverlays(vc.mapView.overlays)
            
            // MARK: 5. add annotations and register views for sites
            for site in incomingSites {
                vc.mapView.addAnnotation(SiteAnnotation(site: site))  // convert query result into annotation object
                vc.mapView.register(SiteAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)  // register annotation
                }
            
            // place the search radius overlay
            vc.addSearchRadiusOverlay(center: location, radius: radius)
                
            // MARK: 6. set the map frame based on search radius dimensions
            // since we already have an overlay, we'll use its geometry to set the map view bounds
            
            let rect = vc.mapView.overlays[0].boundingMapRect
            
            // rect is the bounding box for the overlay, but we want it to be juuuuuust a little bit wider.
            // rect.width is a get-only method, and there is no setter.
            // thus, we're going to derive a new rectangle from the existing one.
        
            let scaledSize = MKMapSize(width: rect.size.width * 1.15, height: rect.size.height * 1.15)
            let frame = MKMapRect(origin: rect.origin, size: scaledSize)  // a new rectangle with the same origin and the larger width
            var region = MKCoordinateRegion(frame)  // the region object which matches the frame
            region.center = location  // recenter the region
            vc.mapView.setRegion(region, animated: true)  // set the region
                
            vc.siteListButton.setTitle("Sites in Radius: \(incomingSites.count)", for: vc.siteListButton.state)
                
            
            }
            
            // MARK:  DONE
            dismiss(animated: true)  // whew!  bye bye, filter viewController!
        }
    }
        
    @IBAction func clearFilters(_ sender: Any) {
        
        // set the initial values
        radiusSlider.setValue(5, animated: true)
        filterSectorPickerView.selectRow(0, inComponent: 0, animated: true)
        releaseTypeSectorPickerView.selectRow(0, inComponent: 0, animated: true)
        carcinogenSwitch.setOn(false, animated: true)
        radiusSliderValueLabel.text = "5 Miles"
        
        // reset the persistent state object
        if let vc = presentingViewController as? ViewController {
            vc.filterParams = ["radius": 5,
                               "sectors": 0,
                               "releaseType": 0,
                               "carcinogen": nil]
        }
        applyFilters(sender)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeFormView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func radiusSliderValueChanged(_ sender: Any) {
        let val = String(Int(radiusSlider.value))
        radiusSliderValueLabel.text = "\(val) Miles"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = presentingViewController as? ViewController {
            filterSectorPickerView.delegate = self
            filterSectorPickerView.dataSource = self
            filterSectorPickerView.tag = 1
            
            releaseTypeSectorPickerView.delegate = self
            releaseTypeSectorPickerView.dataSource = self
            releaseTypeSectorPickerView.tag = 2
            let radius = Float(vc.filterParams["radius"] as! Int)
            radiusSlider.setValue(radius, animated: true)
            radiusSliderValueLabel.text = "\(Int(radius)) Miles"
            filterSectorPickerView.selectRow(vc.filterParams["sectors"] as! Int, inComponent: 0, animated: true)
            releaseTypeSectorPickerView.selectRow(vc.filterParams["releaseType"] as! Int, inComponent: 0, animated: true)
            if vc.filterParams["Carcinogen"] != nil {
                carcinogenSwitch.isOn = true
                }
            }
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
