# Tezal - Equipment Rental Platform

Tezal is a mobile application connecting equipment owners with renters, streamlining the process of renting construction, agricultural, and other specialized equipment.

## 📱 About Tezal

Tezal provides a dual-role platform serving both equipment renters and owners. The platform allows users to browse, search, book, and list equipment within a streamlined interface customized for each user role.

![Tezal Banner](https://via.placeholder.com/800x200?text=Tezal+Equipment+Rental+Platform)

## 🚀 Core Features

### User Management
- **Dual User Roles**: Support for both equipment renters and owners
- **Authentication**: Secure signup/login system with role selection
- **Role-specific Dashboards**: Tailored experiences based on user type

### Equipment Management
- **Browsing & Detailed Views**: Complete equipment listings with specifications, images, pricing
- **Advanced Search & Filtering**: Dynamic filters for equipment type, location, price range, availability
- **Equipment Listing Creation**: Owners can easily create, edit and manage listings

### Booking System
- **Streamlined Booking Flow**: Simple date selection and request submission
- **Owner Approval Process**: Request management for equipment owners
- **Booking Status Tracking**: Real-time updates on rental status

### Reviews & Ratings
- **Post-rental Reviews**: Rating system for completed rentals
- **Public Profile Ratings**: Transparency through visible owner ratings

## 🛠️ Technologies

### Backend
- **Go (Golang)**: High-performance, concurrent backend language
- **Microservices Architecture**: Modular services for better scalability and fault isolation
- **Docker**: Containerization for consistent development and deployment
- **PostgreSQL**: Reliable relational database for transactional data
- **Redis**: In-memory store for caching and temporary data
- **Elasticsearch**: High-performance search engine for complex queries

### Mobile
- **Dart & Flutter**: Cross-platform mobile development framework
- **Firebase**: Integration for authentication, notifications, and analytics

## 🏁 Getting Started

### Prerequisites
- Go 1.19+
- Docker and Docker Compose
- PostgreSQL 14+
- Redis 6+
- Elasticsearch 7+

### Setup & Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/abdusss111/tezal-back.git
   cd tezal-back
   ```

2. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. Start the services using Docker Compose:
   ```bash
   docker-compose up -d
   ```

4. Run database migrations:
   ```bash
   go run cmd/migrate/main.go
   ```

5. Start the development server:
   ```bash
   go run cmd/api/main.go
   ```

6. The API will be available at `http://localhost:8080`

## 📚 API Documentation

API documentation is available via Swagger at `http://localhost:8080/swagger/index.html` when the server is running.

## 🧪 Testing

Run the test suite:

```bash
go test ./...
```

## 🔄 Development Workflow

1. Create a new branch for each feature or bugfix
2. Write tests for new functionality
3. Implement your changes
4. Submit a pull request for review

## 🚧 Current Development Challenges

1. **Search & Filtering System**: Implementing high-performance search with Elasticsearch
2. **Elasticsearch Index Stability**: Ensuring consistent data indexing under high load
3. **Microservices Communication**: Managing efficient data flow between services
4. **Dual User Role Experience**: Creating intuitive interfaces for different user types

## 📋 Upcoming Features

### Equipment Listing Sharing (In Progress)
- Share listings via messaging platforms, social media, and email
- Deep linking to direct users to specific equipment listings
- Web-based fallback for users without the app installed

## 👥 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Contact

For questions or support, please open an issue on this repository or contact the maintainers.
