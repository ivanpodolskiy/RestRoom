//
//  RoomInfo.swift
//  RestRoom
//
//  Created by user on 23.09.2024.
//

import UIKit

enum RoomType: String, Codable, CaseIterable {
    case chair = "Масажные кресла Yamaguchi"
    case neckMassagers = "Массажеры для шеи и головы"
    case aromatherapy = "Ароматерапия"
    case meditations = "Медитации"
    case musicalBowls = "Музыкальные чаши"
}

struct RoomInfo  {
    var type: RoomType
    var freeImageName: String {
        switch type {
        case .aromatherapy: return "freeAromatherapy"
        case .chair: return "freeChair"
        case .meditations: return  "freeMeditations"
        case .musicalBowls: return "freeMusicalBowls"
        case .neckMassagers: return "freeNeckMassagers"
        }
    }
    
    var bookedImageName: String {
        switch type {
        case .aromatherapy:  return "bookedAromatherapy"
        case .chair: return "bookedChair"
        case .meditations: return  "bookedMeditations"
        case .musicalBowls: return "bookedMusicalBowls"
        case .neckMassagers: return "bookedNeckMassagers"
        }
    }
    
    var seatsCount: Int {
        switch type {
        case .chair, .neckMassagers: return 3
        case .aromatherapy, .meditations, .musicalBowls: return 4
        }
    }
}
