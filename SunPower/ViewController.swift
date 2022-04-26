import UIKit
import CoreLocation
import Alamofire
class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var tipKozeLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var minutiLabel: UILabel!
    
    
    var tipKoze: String = Utilities().getTipKoze(){
        didSet {
            updateTipKozeLabel()
            Utilities().setTipKoze(value: tipKoze)
        }
    }
    var kordinate:CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    
    var uvIndex:Double = 10
    
    var racunaVremeMinut: Int = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        updateTipKozeLabel()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("autorizacija promenjena")
        if manager.authorizationStatus == .authorizedWhenInUse{
            getLocation()
    }  else {
        print("odbijena lokacija")
        let upozorenje = UIAlertController(title: "Error", message: "Potrebno je dozvoliti lokaciju", preferredStyle: .alert)
        self.present(upozorenje, animated: true, completion: nil)
        upozorenje.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
}
    func getLocation(){
        if let loc = locationManager.location {
            kordinate = loc.coordinate
            print(kordinate)
            getWeatherData()
            
        }
    }
    
    func getWeatherData(){
        if let krd = kordinate {
            let url = WeatherAPI(lat: String(krd.latitude), lon: String(krd.longitude)).getFullWeatherURL()
            AF.request(url).responseJSON {
                response in switch response.result{
                case .success(let value):
                print("Uspesno")
                    if let JSON = value as? [String: Any]{
                        let data = JSON["data"] as? Array<Any>
                        let vals = data?[0]
                        if let d = vals as? [String: Any] {
                            if let uv = d["uv"] as? Double {
                                self.uvIndex = uv
                                print(uv)
                                self.updateUI(dataSuccess: true)
                                break
                            }
                           
                        }
                    }
                
                    
                case .failure( _):
                    print("Neuspesno")
                    self.updateUI(dataSuccess: false)
                }
            }
        }
    }
    func updateUI (dataSuccess: Bool){
        DispatchQueue.main.async{
            if !dataSuccess {
                self.getWeatherData()
                return
            }
            self.racunaVremeMinut = Int(Vreme().racunaVreme(tipKoze: self.tipKoze, uvIndex: self.uvIndex))
            self.minutiLabel.text = String(self.racunaVremeMinut)
            self.activityIndicator.stopAnimating()
        }
    }
   
    
    @IBAction func podsetnikButtonTap(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]){
            (granted, error) in if !granted {
                return
            }
            let content = UNMutableNotificationContent()
            content.title = "Isteklo vreme"
            content.body = "Pecenjeee"
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.racunaVremeMinut*60), repeats: false)
            let request = UNNotificationRequest(identifier: "OpekotinaNotifikacija", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
            print("uspesno ste postavili notifikaciju")
        }
    }
    
    @IBAction func promeniButtonTap(_ sender: UIButton) {
        let upozorenje = UIAlertController(title: "Izaberi", message: "Izaberi tip koze", preferredStyle: .actionSheet)
        for s in TipKoze().sviTipoviKoze(){
            upozorenje.addAction(UIAlertAction(title: s, style: .default, handler: {(action) in
                self.tipKoze = s
                self.updateTipKozeLabel()
            }))
        }
        self.present(upozorenje, animated: true, completion: nil)
    }
    func updateTipKozeLabel(){
        tipKozeLabel.text = tipKoze
    }
    
}

