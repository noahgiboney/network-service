# NetworkService
Swift package for simplifiyng networking in any swift project. 

## Usage

# Fetching Data (GET Request)
```
let result: Result<User, NetworkError> = await URLSession.shared.fetch(path: "https://api.example.com/users/1")

switch result {
case .success(let user):
    print("User fetched successfully: \(user.name)")
case .failure(let error):
    print("Failed to fetch user: \(error.localizedDescription)")
}
```

## Install
Swift Package Manager

## LICENSE
MIT License
