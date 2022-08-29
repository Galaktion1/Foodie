//
//  APIFetchModel.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import Foundation

// MARK: - FetchedData
struct FetchedData: Codable {
    let restaurants: [Restaurant]?
}

// MARK: - Restaurant
struct Restaurant: Codable {
    let id: Int
    let name: String
    let rating: Int
    let restaurantImg: String?
    let descriptions: Descriptions
    let foods: [Food]?
}

// MARK: - Descriptions
struct Descriptions: Codable {
    let address, city, phone, mail: String
    let website: String?
    let shortAddress, descriptionsOpen: String

    enum CodingKeys: String, CodingKey {
        case address, city, phone, mail, website, shortAddress
        case descriptionsOpen = "open"
    }
}

// MARK: - Food
struct Food: Codable {
    let foodID: Int
    let foodName: String
    let price: Double
    let foodRank, cuisine, about: String
    let foodImgURL: String?

    enum CodingKeys: String, CodingKey {
        case foodID = "foodId"
        case foodName, price, foodRank, cuisine, about
        case foodImgURL = "foodImgUrl"
    }
}
