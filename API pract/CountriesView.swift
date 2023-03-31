//
//  ContentView.swift
//  API pract
//
//  Created by Sabit Islam on 3/22/23.
//

import SwiftUI
import SwiftyJSON
import Alamofire

struct CountriesView: View {
   @StateObject var countriesModel = CountriesModel()
    
    var body: some View {
    
        List(countriesModel.countries) { country in
            Text(country.name)
        }
        .task {
            await self.countriesModel.reload()
        }
        .refreshable {
            await self.countriesModel.reload()
        }
    }
}




struct Country: Identifiable, Codable {
    var id: String
    var name: String
    

    }
@MainActor
class CountriesModel: ObservableObject {
    @Published var countries: [Country] = []
    func reload() async {
        let url = URL(string:"https://www.ralfebert.de/examples/v3/countries.json")!
        let urlSession = URLSession.shared
        do {
            let (data, _) = try await urlSession.data(from: url)
            self.countries = try JSONDecoder().decode([Country].self, from: data)
            }
        catch {
            debugPrint("Error loading \(url): \(String(describing: error))")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesView()
    }
}
