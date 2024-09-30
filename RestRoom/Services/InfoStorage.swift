//
//  InfoStorage.swift
//  RestRoom
//
//  Created by user on 28.09.2024.
//

import Foundation

class InfoStorage {
    static let shared = InfoStorage()
    private let defaults = UserDefaults.standard
    private let roomTypeKey = "roomType"
    private let serialNumberKey = "serialNumber"
    
    func saveInfo(roomType: RoomType, serialNumber: String?) {
        if let encodedRoomInfo = try? JSONEncoder().encode(roomType) {
            defaults.set(encodedRoomInfo, forKey: roomTypeKey)
        }
        defaults.set(serialNumber, forKey: serialNumberKey)
    }
    
    func getInfo() -> (roomType: RoomType?, serialNumber: String?) {
        guard let saveRoomTypeData = defaults.data(forKey: roomTypeKey),
              let decodedRoomType = try? JSONDecoder().decode(RoomType.self, from: saveRoomTypeData) else {
            return (nil, nil)
        }
        guard let  serialNumber = defaults.string(forKey: serialNumberKey) else {
            return (decodedRoomType, nil)
            
        }
        return (decodedRoomType, serialNumber)
    }
}
