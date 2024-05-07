# TheDancingPony

## Overview
TheDancingPony is a web application built using the Phoenix Framework, designed to manage a restaurant's menu, user authentication, and dish ratings. This application is ready for production with secure authentication mechanisms and a robust testing suite.

It was designed with a Lord of Rings flavour in mind in exchange for a box of treasure. No shady dealings concerning rings occurred in the creation of this codebase.

## Getting Started

### Prerequisites
- Elixir 1.16.2
- Phoenix Framework (at least 1.7.2)
- PostgreSQL

### Installation
1. Clone the repository:
   ```
   bash
   git clone https://github.com/your-repository/TheDancingPony.git
   ```
2. Navigate to the project directory:
   ```
   bash
   cd TheDancingPony
   ```
3. Install dependencies:
   ```
   bash
   mix deps.get
   ```

### Setup Database
1. Create and migrate your database:
   ```
   bash
   mix ecto.setup
   ```

### Start the Application
1. Start the Phoenix server:
   ```
   bash
   mix phx.server
   ```
   Alternatively, you can run it inside IEx (Interactive Elixir) for a more interactive experience:
   ```
   bash
   iex -S mix phx.server
   ```

## Testing

1. **Install Postman**: Download and install Postman from [postman.com](https://www.postman.com/downloads/).

2. **Configure the Environment**:
   - Create a new environment in Postman.
   - With the server running, test against `http://localhost:4000`

3. **Create a User**:
   - Make a POST request to the `/api/users` endpoint with a user payload:
     ~~~json
     {
      "user": {
        "nickname": "Frodo",
        "password": "theshire123"
      }
    }
     ~~~
   - In the response, you'll receive a JWT. Copy this token to the Authorization tab as type "Bearer Token", or whatever your equivalent header is if you're not using Postman.

4. **Making Authenticated Requests**:
   - For any request that requires authentication, use the `Authorization` header.
   - Set it to `Bearer {{token}}` where `{{token}}` utilizes the environment variable.

5. **Test Endpoints**:
   - **Create Dish**: POST `/api/dishes`
     ~~~json
     {
      "dish": {
        "name": "Lembas",
        "description": "Elven bread",
        "price": "5.00"
      }
     }
     ~~~
   - **Read Dish**: GET `/api/dishes/{id}`
   - **Search Dishes by Name**: GET `/api/dishes?name=Lembas`
   - **Update Dish**: PUT `/api/dishes/{id}`
     ~~~json
     {
      "dish": {
        "name": "New Lembas",
        "description": "Elven bread",
        "price": "5.50"
      }
     }
     ~~~
   - **Delete Dish**: DELETE `/api/dishes/{id}`
   - **Rate a Dish**: POST `/api/rate/`
     ~~~json
    {
        "rating": {
          "dish_id": 1,
          "value": 5
        }
    }
     ~~~

This setup will allow you to test all aspects of the API, including secured endpoints that require authentication. Smeagol isn't allowed around here, see what happens if you create a user with that nickname and try to rate a dish!

## TODO
- [x] Implement your classic REST API for The Dancing Pony
- [x] Implement a custom user model with a "nickname" field
- [x] Implement a dish model with name, description, and price
  - [x] Ensure name and description fields are unique
- [x] Provide an endpoint to authenticate with the API using username, password
  - [x] Return a JWT for authentication in future requests
- [x] Provide REST resources for the authenticated user for the Dish resource
- [x] Ensure users can only rate dishes, but only once
- [x] Stop that dirty _Smeagol_ ruining our reviews (and introducing é into my codebase :P)
- [x] Add automated test coverage
- [] Nicer error messages in general (when unauthenticated or malformed request)
- [] Add monitoring
- [] Implement automated CI builds
- [] Claim my promised treasure
