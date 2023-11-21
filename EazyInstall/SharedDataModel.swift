//
//  SharedDataModel.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 11/17/23.
//
import SwiftUI
import Foundation


class SharedDataModel: ObservableObject {
    @Published var posts: [String] = []
}
