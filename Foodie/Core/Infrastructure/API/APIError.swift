//
//  APIError.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 19.09.22.
//

import Foundation

enum ApiError: Error {
    case invalidUrl
    case httpError
    case decodingError
}
