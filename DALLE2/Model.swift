//
//  Model.swift
//  DALLE2
//
//  Created by Ming on 19/10/2022.
//

import SwiftUI

struct Model : Codable {
    let result : [Result]
}

struct Result : Codable {
    let id : String
    let object : String
    let created : Int
    let generation_type : String
    let generation : Generation
    let task_id : String
    let prompt_id : String
    let is_public : Bool
}

struct Generation : Codable {
    let image_path : String
}


struct DImage: Identifiable, Codable {
    let id: Int
    let url: String
}
