

import Foundation

class Vreme{
    let btip1: Double = 67
    let btip2: Double = 100
    let btip3: Double = 200
    let btip4: Double = 300
    let btip5: Double = 400
    let btip6: Double = 500
    private var uvIndex: Double = 10
    
    func racunaVreme (tipKoze: String, uvIndex: Double) -> Int {
        self.uvIndex = uvIndex
        switch tipKoze {
        case TipKoze().tip1:
            return _racunaVreme(tipKoze: btip1)
        case TipKoze().tip2:
            return _racunaVreme(tipKoze: btip2)
        case TipKoze().tip3:
            return _racunaVreme(tipKoze: btip3)
        case TipKoze().tip4:
            return _racunaVreme(tipKoze: btip4)
        case TipKoze().tip5:
            return _racunaVreme(tipKoze: btip5)
        case TipKoze().tip6:
            return _racunaVreme(tipKoze: btip6)
        default: return 5
        }
    }
    private func _racunaVreme (tipKoze: Double) -> Int {
        if uvIndex == 0 {
            uvIndex = 0.5
        }
        let vreme = tipKoze / self.uvIndex
        print("Vreme dozvoljeno na suncu je: " + String(vreme))
        return Int(vreme)
    }
    
    
}
