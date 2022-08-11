// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct FetchedData: Codable {
    let restaurants: [Restaurant]?
}

// MARK: - Restaurant
struct Restaurant: Codable {
    let id: Int?
    let name: String?
    let rating: Int?
    let restaurantImg: String?
    let descriptions: Descriptions?
    let foods: [Food]?
}

// MARK: - Descriptions
struct Descriptions: Codable {
    let address, city, phone, mail: String?
    let website, shortAddress, descriptionsOpen: String?

    enum CodingKeys: String, CodingKey {
        case address, city, phone, mail, website, shortAddress
        case descriptionsOpen = "open"
    }
}

// MARK: - Food
struct Food: Codable {
    let foodID: Int?
    let foodName: String?
    let price: Double?
    let foodRank, cuisine, about: String?
    let foodImgURL: String?

    enum CodingKeys: String, CodingKey {
        case foodID = "foodId"
        case foodName, price, foodRank, cuisine, about
        case foodImgURL = "foodImgUrl"
    }
}
