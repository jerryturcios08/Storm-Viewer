//
//  StormImage.swift
//  Storm Viewer
//
//  Created by Jerry Turcios on 1/16/20.
//  Copyright © 2020 Jerry Turcios. All rights reserved.
//

import Foundation

struct StormImage: Codable, Comparable {
    var imageName: String
    var viewCount = 0

    static func < (lhs: StormImage, rhs: StormImage) -> Bool {
        return lhs.imageName < rhs.imageName
    }
}
