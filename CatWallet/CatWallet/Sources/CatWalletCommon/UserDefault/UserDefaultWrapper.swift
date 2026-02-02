//
//  UserDefaultWrapper.swift
//  CatWallet
//
//  Created by Andres Perdomo on 31/01/26.
//

import Foundation

final class UserDefaultWrapper {
    @discardableResult static func set<T: Codable>(value: T, forKey key: String) -> Bool {
        let defaults = UserDefaults.standard

        if let array = value as? [Any], array.first is Codable {
            do {
                let encoded = try JSONEncoder().encode(value)
                defaults.set(encoded, forKey: key)
                return true
            } catch {
                return false
            }
        }

        if value is String ||
            value is Int ||
            value is Double ||
            value is Float ||
            value is Bool ||
            value is Data ||
            value is [Any] ||
            value is [String: Any] {
            defaults.set(value, forKey: key)
            return true
        }

        do {
            let encoded = try JSONEncoder().encode(value)
            defaults.set(encoded, forKey: key)
            return true
        } catch {
            return false
        }
    }

    static func get<T: Codable>(key: String, as type: T.Type) -> T? {
        let defaults = UserDefaults.standard

        if let data = defaults.data(forKey: key) {
            do {
                let decoded = try JSONDecoder().decode(type, from: data)
                return decoded
            } catch {
                return nil
            }
        }

        return defaults.object(forKey: key) as? T
    }

    @discardableResult static func delete(key: String) -> Bool {
        UserDefaults.standard.removeObject(forKey: key)
        return true
    }

    static func clearAll() {
        guard let bundleId = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleId)
        UserDefaults.standard.synchronize()
    }
}
