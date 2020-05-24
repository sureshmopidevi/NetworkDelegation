//
//  ContentView.swift
//  NetworkDelegation
//
//  Created by APPLE  on 23/05/20.
//  Copyright © 2020 Suresh Mopidevi. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State var data: [String] = ["😊"]

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20.0) {
                VStack(alignment: .center, spacing: 20.0) {
                    Button("GET SUCCESS RESPONSE") {
                        self.data.removeAll()
                        NetworkManager.shared.fetch()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                    Button("GET FAILED RESPONSE") {
                        self.data.removeAll()
                        NetworkManager.shared.fetch(urlString: "2398")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
                }.padding()
                delegatesList()
            }
            .navigationBarTitle("Delegate Pattern").onAppear {
                NetworkManager.shared.delegate = self
            }
        }
    }

    func delegatesList() -> some View {
        List {
            ForEach(data, id: \.self) { message in
                HStack(alignment: .center) {
                    Spacer()
                    VStack {
                        Text(message)
                            .fontWeight(message.contains("✅") ? .regular : .medium)
                            .foregroundColor(.init(white: 0.15))
                            .font(.system(message.contains("✅") ? .body : .title, design: .rounded))
                            .multilineTextAlignment(message.contains("✅") ? .leading : .center)
                            .padding()
                    }
                    Spacer()
                }.background(Color(white: 0.92))
                    .cornerRadius(8)
            }
        }.onAppear {
            UITableView.appearance().separatorStyle = .none
        }
    }
}

extension ContentView: NetworkDelegate {
    func didReceivedResponse(response: String) {
        data.append("✅ GOT RESPONSE \n\(response)")
    }

    func didStartedAPICall() {
        data.append("🎬 API CALL STARTED")
    }

    func didFailedToGetResponse(error: String) {
        data.append("🛑 API CALL ENDED WITH ERROR \n\(error)")
    }

    func didEndAPICall() {
        data.append("🤞 FINISHED API CALL")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
