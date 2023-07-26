//
//  ContentView.swift
//  NewsApp2
//
//  Created by Дарья Яцынюк on 19.07.2023.
//

import SwiftUI




struct Response: Codable {
    var articles: [Articles]
}

struct Articles: Codable {
    var author : String?
    var title: String
    var description: String
    var urlToImage: URL?
    var url: URL?
}

struct ContentView: View {
    @State var articles = [Articles]()
    @State private var backgroundColor = LinearGradient(colors: [.blue, .cyan, .white], startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationView {
            List(articles, id: \.author) { item in
                Section {
                    Text(item.author ?? "")
                        .font(.headline)
                    HStack {
                        AsyncImage(url: item.urlToImage) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        NavigationLink {
                            Text(item.description)
                            AsyncImage(url: item.urlToImage) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 300, height: 300)
                            
                            Button {
                                if let url = item.url {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Text("View more detail")
                            }
                            
                        } label: {
                            HStack {
                                Text(item.title)
                                    .font(.headline)
                            }
                        }
                    }
                }
//                .background(
//                    ZStack {
//                        backgroundColor
//                    }
//                )
            }
            
            .task {
//                await loadData()
            }
        }
    }
        
    
    func loadData() async {
        print("Making request...")
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2023-07-18&sortBy=publishedAt&apiKey=3bbd3e96ebce4b71b7092df44423e8f3") else {
            print("Error")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print(String.init(data: data, encoding: .utf8))
            let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
            articles = decodedResponse.articles
        } catch {
            print(error)
        }
    }
}

struct ContenView_Previews: PreviewProvider {
    static var previews: some View {
    ContentView(articles: [
        .init(author: "Daria Yats", title: "Something importamt", description: "And in the case you only want to control the scale of the image, you can use the AsyncImage with the scale modifier. The default value of the scale is 1. Let's try using scale value of 2", urlToImage: .init(string: "https://br.cdn.pxr.nl/news/2023/07/17/9547cd544ea2c72834f3ede55c2190a21a996abd.jpg"), url: .init(string: "https://biztoc.com/x/f2e1243e14fc35ce"))
    ])
    }
}
