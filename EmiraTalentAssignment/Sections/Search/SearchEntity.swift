//
//  SearchEntity.swift
//  EmiraTalentAssignment
//
//  Created by Khawar Shahzad on 22/10/2022.
//

import Foundation


struct SearchEntity : Codable {
    let fileContent : String?
    
    enum CodingKeys: String, CodingKey {
        case fileContent = "fileContent"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fileContent = try values.decodeIfPresent(String.self, forKey: .fileContent)
    }
}

