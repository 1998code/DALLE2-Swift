//
//  ContentView.swift
//  DALLE2
//
//  Created by Ming on 19/10/2022.
//

import SwiftUI
import CardStack

struct ContentView: View {
    
    @AppStorage("token") var token: String = "sk-xxxx"
    @AppStorage("prompt") var prompt: String = ""
    @AppStorage("number") var number: Int = 3
    @State var images = [DImage]()
    @State var showTokenSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                if token == "sk-xxxx" || token == "" {
                    Label("Input a token first", systemImage: "person.badge.key")
                }
                else {
                    HStack {
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .foregroundColor(prompt == "" ? .gray : .primary)
                        TextField("3D render of a cute tropical fish in an aquarium on a dark blue background, digital art", text: $prompt)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    .onSubmit {
                        callData()
                    }
                    Spacer()
                    if images.isEmpty && prompt != "" {
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
                Stepper(value: $number, in: 1...10) {
                    Text("\(number)")
                }
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
            else if prompt != "" {
                callData()
            }
        }
    }
    
    func callData() {
        images = [DImage]()
        let url = URL(string: "https://dalle2.vercel.app/api/images?t=\(token)&p=\(prompt.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\"", with: "'"))&n=\(number)")!
        print(url)
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
                    images.append(DImage(id: id, url: i.url))
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
