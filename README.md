# NetworkService
Simple swift package for making easy network calls.

## Install
Swift Package Manager

## Usage
This service is an extension on <code>URLSession</code>, making it easy to make networks calls with async/await. There is automatic encdoing and decoding of the <code>Codable</code> type and error handling with a custom <code>NetworkError</code>. You can pass function custom JSON Encoders and Decoders, or use the defaults.

### Import The Package
```
import NetworkService
```

### GET Request
Use the fetch function to make a GET request to an API and decode the response into a Codable object.
```
struct User: Codable {
    let id: Int
    let name: String
}

let user: User = try await URLSession.shared.fetch(path: "https://api.example.com/user/1")
```

### POST Request
Use the post function to send a POST request with a Codable object to the API and decode the response.
```
let newUser = User(id: 1, "Noah"))
let responsePost: Post = try await URLSession.shared.post(path: "https://api.example.com/users", object: newUser)
```
### DELETE Request
Use the delete function to send a DELETE request to the API. The function returns optional data depending on the API response for flexability.
```
let responseData = try await URLSession.shared.delete(path: "https://api.example.com/user/1")
if let data = responseData {
    print("Delete response: \(data)")
}
```

### PUT Request
Use the update function to send a PUT request to the API. This function replaces a Codable object with a new object.
```
user.name = "New Name"
user.bio = "New Bio"
let updatedUser: User = try await URLSession.shared.update(path: "https://api.example.com/users", updatedObject: user)
```

### PATCH Request
Use the patch function send patch request ot the API. This updates only specified fields, you must pass it a dictionary with these fields.
```
let updatedFields = ["name": "Noah", "bio": "New Bio"]
let updatedUser: User = try await URLSession.shared.patch(patch: "https://api.example.com/users", fields: updatedFields)
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
