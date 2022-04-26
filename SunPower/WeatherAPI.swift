

import Foundation

struct WeatherAPI {
    private let baseURL = "https://api.weatherbit.io/v2.0/current?"
    private let key = "&key=139c61547a3e4cea85417ed478a6abbc"
    private var kordinate = ""
    
    init(lat: String, lon:String){
        self.kordinate = "lat=\(lat)&lon=\(lon)"
    }
    func getFullWeatherURL () -> String{
        return baseURL + kordinate + key
    }
}
