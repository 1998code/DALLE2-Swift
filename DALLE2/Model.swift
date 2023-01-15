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
    let url: String
}

struct DImage: Identifiable, Codable {
    let id: Int
    let url: String
}
