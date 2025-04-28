//
//  APIService.swift
//  KinjalKCTATracker
//
//  Created by kinjal kathiriya  on 4/27/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "https://lapi.transitchicago.com/api/1.0/"
    private let apiKey = "77a059e4ef76404abbe729fab7b55693"
    
    private var useMockData = true  // Set to true initially to ensure we show data
    
    func fetchTrainLines(completion: @escaping (Result<[TrainLine], Error>) -> Void) {
        if useMockData {
            completion(.success(mockTrainLines()))
            return
        }
        
        let urlString = "\(baseURL)ttpositions.aspx?key=\(apiKey)&outputType=JSON"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        print("Fetching from: \(urlString)") // Debug print
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NetworkError.noData))
                return
            }
            
            print("Raw data received: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
            
            do {
                // Parse the JSON first to understand its structure
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let ctatt = json["ctatt"] as? [String: Any],
                   let routes = ctatt["route"] as? [[String: Any]] {
                    
                    // Map the data to our model
                    let trainLines = routes.compactMap { routeData -> TrainLine? in
                        guard let name = routeData["@name"] as? String,
                              let color = self.mapRouteNameToColor(name),
                              let trains = routeData["train"] as? [[String: Any]] else {
                            return nil
                        }
                        
                        // Create unique stations from train data
                        var stationsDict: [String: Station] = [:]
                        for train in trains {
                            if let nextStopId = train["nextStpId"] as? String,
                               let nextStopName = train["nextStaNm"] as? String {
                                stationsDict[nextStopId] = Station(name: nextStopName, stopId: nextStopId)
                            }
                        }
                        
                        let stations = Array(stationsDict.values)
                        return TrainLine(name: name, color: color, stations: stations)
                    }
                    
                    completion(.success(trainLines))
                } else {
                    print("JSON format not as expected")
                    completion(.success(self.mockTrainLines()))
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.success(self.mockTrainLines()))
            }
        }.resume()
    }
    
    func fetchArrivals(for stopId: String, completion: @escaping (Result<[Arrival], Error>) -> Void) {
        if useMockData {
            completion(.success(mockArrivals()))
            return
        }
        
        let urlString = "\(baseURL)ttarrivals.aspx?key=\(apiKey)&outputType=JSON&stpid=\(stopId)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                // Parse the JSON first to understand its structure
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let ctatt = json["ctatt"] as? [String: Any],
                   let eta = ctatt["eta"] as? [[String: Any]] {
                    
                    // Map the data to our model
                    let arrivals = eta.compactMap { etaData -> Arrival? in
                        guard let stationName = etaData["staNm"] as? String,
                              let destination = etaData["destNm"] as? String,
                              let arrivalTime = etaData["arrT"] as? String,
                              let delayedStr = etaData["isDly"] as? String else {
                            return nil
                        }
                        
                        // Format the arrival time
                        let formattedTime = self.formatArrivalTime(arrivalTime)
                        let isDelayed = delayedStr == "1"
                        
                        return Arrival(stationName: stationName,
                                     destination: destination,
                                     arrivalTime: formattedTime,
                                     isDelayed: isDelayed)
                    }
                    
                    completion(.success(arrivals))
                } else {
                    print("JSON format not as expected")
                    completion(.success(self.mockArrivals()))
                }
            } catch {
                print("Decoding error: \(error)")
                completion(.success(self.mockArrivals()))
            }
        }.resume()
    }
    
    // Helper method to format time from API format to readable format
    private func formatArrivalTime(_ timeString: String) -> String {
        // CTA API returns time in format: "2025-04-27T14:30:45"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.timeStyle = .short
        
        if let date = inputFormatter.date(from: timeString) {
            return outputFormatter.string(from: date)
        }
        return timeString
    }
    
    // Helper method to map route names to colors
    private func mapRouteNameToColor(_ routeName: String) -> String? {
        let routeColors = [
            "Red": "Red",
            "Blue": "Blue",
            "Brn": "Brown",
            "G": "Green",
            "Org": "Orange",
            "P": "Purple",
            "Pink": "Pink",
            "Y": "Yellow"
        ]
        return routeColors[routeName]
    }
    
    // MARK: - Mock Data
    private func mockTrainLines() -> [TrainLine] {
        return [
            TrainLine(name: "Red Line", color: "Red", stations: [
                Station(name: "Howard", stopId: "40900"),
                Station(name: "Morse", stopId: "40100"),
                Station(name: "Loyola", stopId: "41300"),
                Station(name: "Granville", stopId: "40760"),
                Station(name: "Thorndale", stopId: "40880"),
                Station(name: "Bryn Mawr", stopId: "41380"),
                Station(name: "Berwyn", stopId: "40340"),
                Station(name: "Argyle", stopId: "41200"),
                Station(name: "Lawrence", stopId: "40770"),
                Station(name: "Wilson", stopId: "40540"),
                Station(name: "Sheridan", stopId: "40080"),
                Station(name: "Addison", stopId: "41420"),
                Station(name: "Belmont", stopId: "41320"),
                Station(name: "Fullerton", stopId: "41220"),
                Station(name: "North/Clybourn", stopId: "40650"),
                Station(name: "Clark/Division", stopId: "40630"),
                Station(name: "Chicago", stopId: "41450"),
                Station(name: "Grand", stopId: "40330"),
                Station(name: "Lake", stopId: "41660"),
                Station(name: "Monroe", stopId: "41090"),
                Station(name: "Jackson", stopId: "40560"),
                Station(name: "Harrison", stopId: "41490"),
                Station(name: "Roosevelt", stopId: "41400")
            ]),
            TrainLine(name: "Blue Line", color: "Blue", stations: [
                Station(name: "O'Hare", stopId: "40890"),
                Station(name: "Rosemont", stopId: "40820"),
                Station(name: "Cumberland", stopId: "40230"),
                Station(name: "Harlem", stopId: "40750"),
                Station(name: "Jefferson Park", stopId: "41280"),
                Station(name: "Logan Square", stopId: "41020"),
                Station(name: "California", stopId: "40570"),
                Station(name: "Western", stopId: "40670"),
                Station(name: "Damen", stopId: "40590"),
                Station(name: "Division", stopId: "40320"),
                Station(name: "Chicago", stopId: "41410"),
                Station(name: "Grand", stopId: "40490"),
                Station(name: "Clark/Lake", stopId: "40380"),
                Station(name: "Washington", stopId: "40370"),
                Station(name: "Monroe", stopId: "40790"),
                Station(name: "Jackson", stopId: "40070"),
                Station(name: "LaSalle", stopId: "41340"),
                Station(name: "Clinton", stopId: "40430"),
                Station(name: "UIC-Halsted", stopId: "40350"),
                Station(name: "Forest Park", stopId: "40390")
            ]),
            TrainLine(name: "Brown Line", color: "Brown", stations: [
                Station(name: "Kimball", stopId: "41290"),
                Station(name: "Francisco", stopId: "40870"),
                Station(name: "Rockwell", stopId: "41010"),
                Station(name: "Western", stopId: "41480"),
                Station(name: "Damen", stopId: "40090"),
                Station(name: "Montrose", stopId: "41500"),
                Station(name: "Irving Park", stopId: "41460"),
                Station(name: "Addison", stopId: "41440"),
                Station(name: "Paulina", stopId: "41310"),
                Station(name: "Southport", stopId: "40360"),
                Station(name: "Belmont", stopId: "41320")
            ]),
            TrainLine(name: "Green Line", color: "Green", stations: [
                Station(name: "Harlem/Lake", stopId: "40020"),
                Station(name: "Oak Park", stopId: "41350"),
                Station(name: "Ridgeland", stopId: "40610"),
                Station(name: "Austin", stopId: "41260"),
                Station(name: "Central", stopId: "40280"),
                Station(name: "Laramie", stopId: "40700"),
                Station(name: "Cicero", stopId: "40480"),
                Station(name: "Pulaski", stopId: "40030"),
                Station(name: "Conservatory", stopId: "41670"),
                Station(name: "Kedzie", stopId: "41070"),
                Station(name: "California", stopId: "41360")
            ]),
            TrainLine(name: "Orange Line", color: "Orange", stations: [
                Station(name: "Midway", stopId: "40930"),
                Station(name: "Pulaski", stopId: "40960"),
                Station(name: "Kedzie", stopId: "40980"),
                Station(name: "Western", stopId: "40310"),
                Station(name: "35th/Archer", stopId: "40120"),
                Station(name: "Ashland", stopId: "41060"),
                Station(name: "Halsted", stopId: "40850"),
                Station(name: "Roosevelt", stopId: "41400"),
                Station(name: "Harold Washington Library", stopId: "40850"),
                Station(name: "LaSalle", stopId: "40160"),
                Station(name: "Quincy", stopId: "40040"),
                Station(name: "Washington/Wells", stopId: "40730")
            ]),
            TrainLine(name: "Pink Line", color: "Pink", stations: [
                Station(name: "54th/Cermak", stopId: "40080"),
                Station(name: "Cicero", stopId: "40970"),
                Station(name: "Kostner", stopId: "40600"),
                Station(name: "Pulaski", stopId: "40150"),
                Station(name: "Central Park", stopId: "40780"),
                Station(name: "Kedzie", stopId: "41040"),
                Station(name: "California", stopId: "40440"),
                Station(name: "Western", stopId: "40740"),
                Station(name: "Damen", stopId: "40210"),
                Station(name: "18th", stopId: "40830"),
                Station(name: "Polk", stopId: "41030"),
                Station(name: "Ashland", stopId: "40170"),
                Station(name: "Morgan", stopId: "41510"),
                Station(name: "Clinton", stopId: "41160"),
                Station(name: "Clark/Lake", stopId: "40380")
            ]),
            TrainLine(name: "Purple Line", color: "Purple", stations: [
                Station(name: "Linden", stopId: "41050"),
                Station(name: "Central", stopId: "41250"),
                Station(name: "Noyes", stopId: "40400"),
                Station(name: "Foster", stopId: "40520"),
                Station(name: "Davis", stopId: "40050"),
                Station(name: "Dempster", stopId: "40690"),
                Station(name: "Main", stopId: "40270"),
                Station(name: "South Boulevard", stopId: "40840"),
                Station(name: "Howard", stopId: "40900"),
                Station(name: "Belmont", stopId: "41320"),
                Station(name: "Wellington", stopId: "41210"),
                Station(name: "Diversey", stopId: "40530"),
                Station(name: "Fullerton", stopId: "41220"),
                Station(name: "Armitage", stopId: "40660"),
                Station(name: "Sedgwick", stopId: "40800"),
                Station(name: "Chicago", stopId: "40710"),
                Station(name: "Merchandise Mart", stopId: "40460"),
                Station(name: "Clark/Lake", stopId: "40380")
            ]),
            TrainLine(name: "Yellow Line", color: "Yellow", stations: [
                Station(name: "Dempster-Skokie", stopId: "40140"),
                Station(name: "Oakton-Skokie", stopId: "41680"),
                Station(name: "Howard", stopId: "40900")
            ])
        ]
    }
    
    private func mockArrivals() -> [Arrival] {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return [
            Arrival(stationName: "Howard", destination: "95th/Dan Ryan",
                   arrivalTime: formatter.string(from: Date().addingTimeInterval(300)), isDelayed: false),
            Arrival(stationName: "Howard", destination: "Loop",
                   arrivalTime: formatter.string(from: Date().addingTimeInterval(600)), isDelayed: true),
            Arrival(stationName: "Howard", destination: "95th/Dan Ryan",
                   arrivalTime: formatter.string(from: Date().addingTimeInterval(900)), isDelayed: false),
            Arrival(stationName: "Howard", destination: "Loop",
                   arrivalTime: formatter.string(from: Date().addingTimeInterval(1200)), isDelayed: false)
        ]
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
    }
}
