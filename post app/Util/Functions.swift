//
//  Functinos.swift
//  post app
//
//  Created by Yudha Setyaji on 2022/7/24.
//

import Foundation

let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
       in: .userDomainMask)
  return paths[0]
}()
