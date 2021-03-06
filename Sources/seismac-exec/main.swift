import Foundation
import smslib
import OSCCore

func startup() {
    print ("========== SMSTest Report ==========")
    let startup = smsStartup(Helper.init(), #selector(Helper.greet))
    if (startup != SMS_SUCCESS) {
        print ("========== end ==========")
        return
    }
    
    let logCalibration = "Loading any saved calibration: "
    if !smsLoadCalibration() {
        print (logCalibration + "no saved calibration.")
    } else {
        print(logCalibration + "success!")
    }
    
    var accel = sms_acceleration.init()
    let p = withUnsafeMutablePointer(to: &accel) { (p) -> UnsafeMutablePointer<sms_acceleration> in
        return p
    }
    
    while true {
        let data = smsGetData(p)
        if (data != SMS_SUCCESS) {
            print ("========== fail ==========")
        } else {
            
            let msg = OSCMessage(address: "/seism", args: ["x", accel.x, "y", accel.y, "z", accel.z])
            let channel: UDPClient? = UDPClient(host: "127.0.0.1", port: 7401)
            msg.send(over: channel!)
            
            print("=====")
            print("x: \(accel.x)")
            print("y: \(accel.y)")
            print("z: \(accel.z)")
            sleep(1)
        }
    }
}

class Helper {
    @objc func greet(startupInfo: String) {
        print(startupInfo)
    }
}

startup()

