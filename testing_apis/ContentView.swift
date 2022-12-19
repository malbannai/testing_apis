//
//  ContentView.swift
//  testing_apis
//
//  Created by Moudhi on 10/12/2022.
//

import SwiftUI

// Articles
let getURL = "https://caresignal.herokuapp.com/get-articles"
let postURL = "https://caresignal.herokuapp.com/add-articles"

// Testing model
struct Article: Decodable{
//    let _id: String
    var mediaclID : Int
    var AutherName: String
    var AutherImage: String
    var content: String
    var ArticleTitle: String
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
   // POST Article
    func postData(a: String, c: String){
        guard let url =  URL(string:postURL)
               else{
                   return        }
        let body: [String: String] = ["mediaclID": "1234", "AutherName": "Dr. Janna", "AutherImage": "", "content": c, "ArticleTitle": a]
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




struct ContentView: View {
    @ObservedObject var viewArticle = ViewArticle()
    @State var ArticleTitle = ""
    @State var content = ""
    @State var submit = false
    
    func buttonAction(){
        viewArticle.postData(a: ArticleTitle, c: content)
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
            
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
