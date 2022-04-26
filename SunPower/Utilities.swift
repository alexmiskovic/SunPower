

import Foundation

class Utilities {
    let tipKozeKey = "tipKoze"
    func getStorage() -> UserDefaults{
        return UserDefaults.standard
    }
    
    func setTipKoze(value: String)
    {
        let defaults = getStorage()
        defaults.setValue(value, forKey: tipKozeKey)
        defaults.synchronize()
    }
    func getTipKoze () -> String {
        let defaults = getStorage()
        if let item = defaults.string(forKey: tipKozeKey){
            return item
        }
        return TipKoze().tip1
    }
    
    
    
}
