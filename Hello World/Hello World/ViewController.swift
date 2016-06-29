//
//  ViewController.swift
//  Hello World
//
//  Created by Philibert Dugas on 2016-06-10.
//  Copyright © 2016 Philibert Dugas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var password: UITextField!
    
    var locationManager = CLLocationManager()
    var peripheralManager = CBPeripheralManager()
    var advertisedData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    
        locationManager.requestAlwaysAuthorization()
        
        let region = CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
            major: 1,
            minor: 67,
            identifier: "Estimotes"
        )
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
        
        self.advertisedData = region.peripheralDataWithMeasuredPower(nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        label.text = beacons.description
        print(beacons)
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Failed monitoring region: \(error.description)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed: \(error.description)")
    }
    
    func beaconRegionWithItem(item: Item) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(proximityUUID: item.uuid,
                                          identifier: item.name)
        return beaconRegion
    }
    
    func startMonitoring(item: Item) {
        let beaconRegion = beaconRegionWithItem(item)
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
        print(locationManager.monitoredRegions.count)

    }
    
    func stopMonitoring(item: Item) {
        let beaconRegion = beaconRegionWithItem(item)
        locationManager.stopMonitoringForRegion(beaconRegion)
        locationManager.stopRangingBeaconsInRegion(beaconRegion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if(peripheral.state == CBPeripheralManagerState.PoweredOn) {
            print("powered on")
            self.peripheralManager.startAdvertising(self.advertisedData as! [String : AnyObject])
        } else if(peripheral.state == CBPeripheralManagerState.PoweredOff) {
            print("powered off")
            self.peripheralManager.stopAdvertising()
        }
    }


}

