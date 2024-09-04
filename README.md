# NetworkService
Swift package for simplifiyng networking in any swift project. 

## Usage
This NetworkLayer extension on <code>URLSession</code> provides an easy way to make network requests in Swift using async/await.

### Overview
The methods provided by the NetworkService—fetch, post, and delete—each return a Result type and are generic to support any <code>Codable</code> type:

- fetch: async -> Result<T, NetworkError>
- post: async -> Result<T, NetworkError>
- delete: async -> Result<Data?, NetworkError>

## Install
Swift Package Manager

## LICENSE
MIT License
