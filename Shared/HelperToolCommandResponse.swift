//
//  HelperToolCommandResponse.swift
//  Mist
//
//  Created by TinHocThucHanh on 21/6/2022.
//

import Foundation

struct HelperToolCommandResponse: Codable {
    let terminationStatus: Int32
    let standardOutput: String?
    let standardError: String?
}
