import Vapor
import HTTP

let drop = Droplet()

let weather = WeatherController()
weather.addRoutes(drop: drop)

drop.get { request in
    let json = try drop.client.get("https://api.darksky.net/forecast/609ac8aa7b058cd762b5744edd712c1f/37.8267,-122.4233", query:["exclude":"minutely,daily,alerts,flags"])
    
    let body = try JSON(bytes: json.body.bytes!)
    let currently = body["currently"]! as JSON
    let hourly = body["hourly"]! as JSON
    
    return try drop.view.make("welcome", Node(node: [
        "time" : TimeKeeper().getSystemTime(),
        "temp" : currently["apparentTemperature"],
        "current-summary" : currently["summary"],
        "hourly-summary" : hourly["summary"],
        "icon" : currently["icon"]
        ]))
    
}

drop.run()
