//
//  DataBaseModel.swift
//  RestRoom
//
//  Created by user on 26.08.2024.
//

import Foundation
import FirebaseDatabase


class DataBaseModel   {
    private var ref = Database.database().reference()
    private let dataF = "yyyy-MM-dd HH:mm:ss:SSS"
    
    func pushNewValue(seatNumber: Int, roomTypeString: String) {
        let snDeviceNumber = InfoStorage.shared.getInfo().serialNumber
        let roomPath = self.ref.child("rooms").child(roomTypeString).child(self.getDateString())
        
        
        self.ref.child("rooms").child(roomTypeString).getData { error, dataSnapshot in
            if let error = error {
                print("Ошибка получения данных: \(error.localizedDescription)")
                return
            }
            var dataDictionary: NSDictionary?
            if let snapshotValue = dataSnapshot?.value as? NSDictionary {
                dataDictionary = snapshotValue
            } else {
                print ("Данные для \(roomTypeString) не найдены. Создана новая команта.")
                dataDictionary = NSDictionary()
            }
            
            let infoValue = self.collectClickData(roomValue: dataDictionary, snDeviceNumber: snDeviceNumber, saetNumber: seatNumber)
            
            roomPath.setValue(infoValue) { error, _ in
                guard error == nil else {
                    print("Ошибка при установке данных: \(error!.localizedDescription)")
                    return
                }
                self.updateTotalCount()
            }
        }
    }
    
    private func collectClickData(roomValue: NSDictionary?, snDeviceNumber: String?, saetNumber: Int) -> [String: Any]{
        let countClickSection = roomValue?.count ?? 0
        
        let clickData: [String: Any] = [
            "seatNum": saetNumber,
            "clickNum": countClickSection + 1,
            "snDevice": snDeviceNumber ?? "none"
        ]
        return clickData
    }
    
    private func updateTotalCount() {
        self.ref.child("totalCount").observeSingleEvent(of: .value) { dataSnapshot in
            if let totalCount = dataSnapshot.value as? Int {
                self.ref.updateChildValues(["totalCount" : totalCount + 1])
            } 
        }
    }
    
    private func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dataF
        return dateFormatter.string(from: Date())
    }
}
