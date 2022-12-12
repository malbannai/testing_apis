//
//  ContentView.swift
//  testing_apis
//
//  Created by Moudhi on 10/12/2022.
//

import SwiftUI

// Articles
let getURL = "https://caresignal.herokuapp.com/get-articles"
let postURL = "https://caresignal.herokuapp.com/post-articles"
// HW
let gethwURL = "https://caresignal.herokuapp.com/get-hw-data"

// Testing model
struct Article: Decodable{
//    let _id: String
    var mediaclID : Int
    var AutherName: String
    var AutherImage: String
    var content: String
    var ArticleTitle: String
}

struct Hardware: Decodable{
//    var _id: String
//    var gpsTime : String
//    var gpsLong: String
//    var gpsAtl: String
//    var counter: String
//    var fallDetect: String
    var body: String
}

struct PostArticle: Decodable {
    var mediaclID : Int
    var AutherName: String
    var AutherImage: String
    var content: String
    var ArticleTitle: String
}

class ViewArticle: ObservableObject{
    @Published var articlesList = [Article]()
    @Published var hwList = [Hardware]()

    
    // Load HW Data
    func loadHardwareData () {
        guard let url =  URL(string: gethwURL) else {return}
        URLSession.shared.dataTask(with: url){(data, res, error) in
            do{
                if let data = data {
                    let result = try JSONDecoder().decode([Hardware].self, from: data)
                    DispatchQueue.main.async {
                        self.hwList = result
                    }
                }else{
                    print("No Data")
                }
            }catch(let error){
                print(error.localizedDescription)
            }
        }.resume()
    }

    // Load Articales
    func loadData () {
        guard let url =  URL(string: getURL) else {return}
        URLSession.shared.dataTask(with: url){(data, res, error) in
            do{
                if let data = data {
                    let result = try JSONDecoder().decode([Article].self, from: data)
                    DispatchQueue.main.async {
                        self.articlesList = result
                    }
                }else{
                    print("No Data")
                }
            }catch(let error){
                print(error.localizedDescription)
            }
        }.resume()
    }
    // Post Articales
    func postData(ArticleTitle: String, content: String){
        guard let url =  URL(string: postURL) else {return}
        
        let body: [String: Any] = ["mediaclID":1234,"AutherName":"JannaTest","AutherImage":"https://cdn-icons-png.flaticon.com/512/3048/3048127.png","content":content,"ArticleTitle":ArticleTitle]
        
        let finalData = try! JSONSerialization.data (withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod="POST"
        request.httpBody = finalData
        
        URLSession.shared.dataTask(with: url){(data, res, error) in
            do{
                if let data = data {
                        let result = try JSONDecoder().decode(PostArticle.self, from: data)
                        print(result)
                    
                }else{
                    print("No Data")
                }
            }catch(let error){
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var viewArticle = ViewArticle()
    @State var ArticleTitle = ""
//    @State var AutherName = ""
    @State var content = ""
    @State var submit = false
    
    func buttonAction(){
        viewArticle.postData(ArticleTitle: ArticleTitle, content: content)
        }
    
    var body: some View {
        TabView{
            NavigationView{
                VStack{
                    List(viewArticle.articlesList, id: \.mediaclID){
                        articlesItem in Text(articlesItem.content)
                    }
                }.onAppear(perform: {
                     viewArticle.loadData()
                }).navigationTitle("Articals")
            }.tabItem{
                Image(systemName: "house")
                Text("Loading Article")
            }
            
            Form{
                TextField("Enter Article Title", text: $ArticleTitle)
                TextField("Enter Article content", text: $content)
                Button(action: {
                           buttonAction()
                       }, label: {
                           Text("Submit")
                       })            }.tabItem{
                Image(systemName: "button")
                Text("Add Article")
            }
            
//            NavigationView{
//                        VStack{
//                            List(viewArticle.hwList, id:\._id){
//                                hwItem in Text(hwItem.gpsTime)
//                            }
//                        }.onAppear(perform: {
//                             viewArticle.loadHardwareData()
//                        }).navigationTitle("Hardware Data")
//            }.tabItem{
//                Image(systemName: "folder")
//                Text("Hardware")
//            }

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
