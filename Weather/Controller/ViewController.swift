import UIKit
import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextFieldArea: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextFieldArea.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let city = searchTextFieldArea.text {
            getWeather(city: city)
        }
        searchTextFieldArea.text = ""
        return true
    }
    
    func getWeather(city: String) {
        //create a URL
        let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        var components = URLComponents(string: baseURL)!
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: "809c19e65d6e866198eac7cb5bce0516")
        ]
        
        guard let url = components.url else {
            print("error")
            return
        }
        //print(url)
        //2.create URLSession
        let session = URLSession(configuration: .default)
        //3.give the session a task
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let safeData = data {
                self.parseJSON(data: safeData)//inside the closure we must use self.method
            }
        }
        //4.start the task
        task.resume()
    }
    
    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherResponse.self, from: data)
            
            //let dataTemp = decodedData.main.temp
            let dataID = decodedData.weather[0].id
            
            DispatchQueue.main.async {
                self.tempLabel.text = String(format: "%.1f°C", decodedData.main.temp)
                self.cityLabel.text = decodedData.name
                self.conditionImageView.image = UIImage(systemName: self.getConditionName(id: dataID))
            }
        } catch { print(error) }
    }
    
    func getConditionName(id: Int) -> String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

