//
//  ContentView.swift
//  post-api
//
//  Created by Moudhi on 19/12/2022.
//

import SwiftUI

struct Response: Codable{
    var results: [Result]
}

struct Result: Codable{
    var trackID: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        VStack {
            List(results, id: \.trackID){
                item in VStack(alignment: .leading){
                    Text(item.trackName).font(.headline)
                    Text(item.collectionName)
                }
            }
        }
        .task {
            await loadData()
        }
    }
    func loadData() async{
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song")else{
            print("Invalid URL")
            return
        }
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
    func postData(){
        guard let url =  URL(string:"https://api.rangouts.com/signin")
               else{
                   return        }
               let body: [String: String] = ["username":  "Hi", "password": "Hi"]
               let finalBody = try? JSONSerialization.data(withJSONObject: body)
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.httpBody = finalBody
               
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
               URLSession.shared.dataTask(with: request){
                   (data, response, error) in
                   
                   guard let data = data else{
                       return
                   }
                   print(data)
                   
               }.resume()
               
           }
       }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
