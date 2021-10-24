//
//  GeneralFunctions.swift
//  Ruminders
//
//  Created by Евгений Сердюков on 24.10.2021.
//

import Foundation
import SwiftUI
import CoreData


func saveClorInData(obj: ListSet) {
    do {
        try obj.color = NSKeyedArchiver.archivedData(withRootObject: UIColor.blue, requiringSecureCoding: false)
    } catch {
        print(error)
    }
}


func getColor(data: Data) -> Color {
    do {
        return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)!)
    } catch {
        print(error)
    }

    return Color.clear
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
