# 🌐 Networking with Protocols 

### Output

![screenshot](https://github.com/sureshmopidevi/NetworkDelegation/blob/master/82753248-e09fe880-9de1-11ea-8882-f7692baaf75f.png?raw=true)

Basic usage of Delegates in Network Calls.

1. Create a Protocol for listening events occuring in Network functions.
```swift
protocol NetworkDelegate {
    func didStartedAPICall()
    func didFailedToGetResponse(error: String)
    func didReceivedResponse(response: String)
    func didEndAPICall()
}
```

2. Create a Singleton class `NetworkManager` to manage networking in application.
- Add `delegate` property to assign `NetworkDeleagate` properties.

```swift
class NetworkManager {
    private init() {}
    var delegate: NetworkDelegate?
    static let shared = NetworkManager()

    func fetch(urlString: String = "https://jsonplaceholder.typicode.com/users") {
        delegate?.didStartedAPICall()
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: URL(string: urlString)!) { data, _, err in
                if let error = err {
                    self.delegate?.didFailedToGetResponse(error: error.localizedDescription)
                }
                if let response = data, let asString = String(data: response, encoding: .utf8) {
                    self.delegate?.didReceivedResponse(response: asString)
                }
                self.delegate?.didEndAPICall()
            }.resume()
        }
    }
}
```

3. Conform to the `NetworkDelegate` in your desired View.

```swift
struct ContentView: View {
    @State var data: [String] = ["😊"]

    var body: some View {
        NavigationView {
          ...
            .navigationBarTitle("Delegate Pattern").onAppear {
                NetworkManager.shared.delegate = self
            }
        }
    }
}
```

4. Make Network call when tapping on buttons

- Here we are making two calls
     1. Success Call with `GET SUCCESS RESPONSE` Button
     2. Failure Call with `GET FAILED RESPONSE` Button

```swift
Button("GET SUCCESS RESPONSE") {
      self.data.removeAll()
       NetworkManager.shared.fetch()
  }

Button("GET FAILED RESPONSE") {
      self.data.removeAll()
      NetworkManager.shared.fetch(urlString: "2398")
   }
```
5. Add the delegate functions and confirm to view

```swift
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

```


