import Foundation
import Postbox
import SwiftSignalKit

public struct ExperimentalUISettings: Equatable, PreferencesEntry {
    public var keepChatNavigationStack: Bool
    public var skipReadHistory: Bool
    
    public static var defaultSettings: ExperimentalUISettings {
        return ExperimentalUISettings(keepChatNavigationStack: false, skipReadHistory: false)
    }
    
    public init(keepChatNavigationStack: Bool, skipReadHistory: Bool) {
        self.keepChatNavigationStack = keepChatNavigationStack
        self.skipReadHistory = skipReadHistory
    }
    
    public init(decoder: PostboxDecoder) {
        self.keepChatNavigationStack = decoder.decodeInt32ForKey("keepChatNavigationStack", orElse: 0) != 0
        self.skipReadHistory = decoder.decodeInt32ForKey("skipReadHistory", orElse: 0) != 0
    }
    
    public func encode(_ encoder: PostboxEncoder) {
        encoder.encodeInt32(self.keepChatNavigationStack ? 1 : 0, forKey: "keepChatNavigationStack")
        encoder.encodeInt32(self.skipReadHistory ? 1 : 0, forKey: "skipReadHistory")
    }
    
    public func isEqual(to: PreferencesEntry) -> Bool {
        if let to = to as? ExperimentalUISettings {
            return self == to
        } else {
            return false
        }
    }
}

func updateExperimentalUISettingsInteractively(accountManager: AccountManager, _ f: @escaping (ExperimentalUISettings) -> ExperimentalUISettings) -> Signal<Void, NoError> {
    return accountManager.transaction { transaction -> Void in
        transaction.updateSharedData(ApplicationSpecificSharedDataKeys.experimentalUISettings, { entry in
            let currentSettings: ExperimentalUISettings
            if let entry = entry as? ExperimentalUISettings {
                currentSettings = entry
            } else {
                currentSettings = .defaultSettings
            }
            return f(currentSettings)
        })
    }
}
