# NetworkService
Simple swift package for making easy network calls.

## Install
Swift Package Manager

## Usage
This service is an extension on <code>URLSession</code>, making it easy to make networks calls with async/await. There is automatic encdoing and decoding of the <code>Codable</code> type and error handling with a custom <code>NetworkError</code>.

### Import The Package
```
import NetworkService
```

### Create a Resource
Create a Resource object to make a URL Request with. You must specify the endpoint, but can optionally pass a json encoder/decoder and/or a dictionary representing the request headers
```
let headers = [Authorization : "Bearer "\(token)"]

let resource = Resource(endpoint: "https://api.example.com", headers: headers)
```

### Perform a Request
Easily perfrom a CRUD operation with one of the methods that is built as a extension to <code>URLSession</code>.
```
let users: [Users] = try await URLSession.shared.get(resource: resource)
```

### Error Handling
The service throws the following exceptions when an error occurs.
```
enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case decodingError
    case encodingError
    case serverResponse
    case error(Error)
```

## LICENSE
MIT License
