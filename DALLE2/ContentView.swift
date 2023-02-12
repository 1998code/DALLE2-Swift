//
//  ContentView.swift
//  DALLE2
//
//  Created by Ming on 19/10/2022.
//

import SwiftUI
import CardStack

struct ContentView: View {
    
    @AppStorage("token") var token: String = "sess-xxxx"
    @AppStorage("query") var query: String = ""
    @State var images = [DImage]()
    @State var showTokenSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                if token == "sess-xxxx" || token == "" {
                    Text("Input a token first")
                }
                else {
                    HStack {
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .foregroundColor(query == "" ? .gray : .primary)
                        TextField("Search here: 3D render of a cute tropical fish in an aquarium on a dark blue background, digital art", text: $query)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    .onSubmit {
                        callData()
                    }
                    Spacer()
                    if images.isEmpty && query != "" {
                        ProgressView()
                        Spacer()
                    } else {
                        CardStack(images) { source in
                            Link(destination: URL(string: source.url)!) {
                                AsyncImage(url: URL(string: source.url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 300, height:300)
                                .cornerRadius(25)
                            }
                        }
                        Spacer()
                    }
                }
            }.padding()
            .toolbar {
                Button(action: { showTokenSheet = true }) {
                    Image(systemName: "person.badge.key")
                }
            }
            .sheet(isPresented:  $showTokenSheet) {
                TextField("Token", text:$token)
                    .padding()
                    .presentationDetents([.fraction(0.1)])
            }
            .navigationTitle("DALLE Swift")
        }
        .onAppear {
            if token == "sess-xxxx" {
                showTokenSheet = true
            }
            else if query != "" {
                callData()
            }
        }
    }
    
    func callData() {
        images = [DImage]()
        let url = URL(string: "https://dalle1.vercel.app/api/dalle2?k=\(token)&q=\(query.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\"", with: "'"))")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Model.self, from: data)
                var id = 0
                for i in result.result {
                    images.append(DImage(id: id, url: i.generation.image_path))
                    id += 1
                }
                print(images)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
