//
//  FileManager-Ext.swift
//  Fluid
//
//  Created by Aidan Pendlebury on 29/04/2020.
//  Copyright © 2020 Aidan Pendlebury. All rights reserved.
//

import Foundation

extension FileManager {
    
    func fetchData<T: Codable>(from file: String) -> T? {
        let path = self.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)
        guard let data = try? Data(contentsOf: path) else { return nil }
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return decodedData
    }
    
    func writeData<T: Codable>(_ data: T, to file: String) {
        let path = self.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file).path
        if let encodedData = try? JSONEncoder().encode(data) {
            guard FileManager.default.createFile(atPath: path, contents: encodedData, attributes: [FileAttributeKey.protectionKey : FileProtectionType.complete ]) else { fatalError("Couldn't create file") }
        }
    }
    
    func deleteData(from file: String) {
        let path = self.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(file)
        do {
            try self.removeItem(at: path)
        } catch {
            fatalError("There was an error deleting the item: \(error.localizedDescription)")
        }
    }
    
}
