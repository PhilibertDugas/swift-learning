//
//  ViewController.swift
//  contacts-bluetooth
//
//  Created by Philibert Dugas on 2016-07-03.
//  Copyright © 2016 Philibert Dugas. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var myCentralManager: CBCentralManager!
    var connectingPeripheral: CBPeripheral?
    var connectedPeripheral: CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myCentralManager = CBCentralManager.init(delegate: self, queue: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch(central.state) {
        case CBCentralManagerState.PoweredOn:
            print("BLE Powered On")
            self.myCentralManager.scanForPeripheralsWithServices([CBUUID.init(string: "02FD04F4-CFFF-4573-B478-F7470A7CF2F2")], options: nil)
            break;
        case CBCentralManagerState.PoweredOff:
            print("BLE Powered Off")
            break;
        default:
            print("Nothing changed")
            break;
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Detect peripheral: \(peripheral.name)")
        self.connectingPeripheral = peripheral
        if(peripheral.state != CBPeripheralState.Connected) {
            print("Trying to connect")
            peripheral.delegate = self
            self.myCentralManager.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Connected to peripheral!")
        peripheral.delegate = self
        self.connectedPeripheral = peripheral
        peripheral.discoverServices([CBUUID.init(string: "02FD04F4-CFFF-4573-B478-F7470A7CF2F2")])
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("failed to connect to peripheral: \(error)")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("Discovered Service!")
        if(error != nil) {
            print("Error when discovering services")
            return;
        }
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if(error != nil) {
            print("Error when discovering characteristics")
            return;
        }
        print("Discovered Char!")
        for charateristic in service.characteristics! {
            peripheral.setNotifyValue(true, forCharacteristic: charateristic)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil {
            print("Error changing notification state")
            return;
        }
        
        if characteristic.isNotifying {
            print("Notification began for: \(characteristic)")
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil {
            print("Error receiving value for char")
            return;
        }
        
        if characteristic.value != nil {
            print("Value received \(characteristic.value)")
        }
    }
    


}

