# Spark - AI Food Recommendation System

A modern food recommendation system that uses AI to suggest personalized food choices based on user preferences, health context, and nutritional needs.

## Features

- **Smart Recommendations**: AI-powered food suggestions based on health context and user preferences
- **Nutritional Tracking**: Track macros, calories, and nutritional intake
- **User Preferences**: Customizable diet styles, budget, and food dislikes
- **Health Context**: Consider sleep, activity level, and mood for better recommendations
- **Modern UI**: Built with React, TypeScript, and Tailwind CSS
- **RESTful API**: FastAPI backend with SQLite database

## Project Structure

```
spark/
├── frontend/          # React + TypeScript + Vite frontend
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── pages/         # Page components
│   │   ├── stores/        # Zustand state management
│   │   └── types/         # TypeScript type definitions
│   └── package.json
├── backend/           # FastAPI backend
│   ├── api/           # API route handlers
│   ├── db/            # Database setup and seed data
│   ├── models/        # Pydantic data models
│   └── main.py        # FastAPI application
└── README.md
```

## Quick Start

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Start the backend server:
   ```bash
   python main.py
   ```

The API will be available at `http://localhost:8000`

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

The frontend will be available at `http://localhost:3000`

## API Endpoints

### Foods
- `GET /api/foods/` - Get all foods
- `GET /api/foods/{food_id}` - Get specific food
- `GET /api/foods/recommend/` - Get food recommendations

### Users
- `GET /api/users/preferences` - Get user preferences
- `PUT /api/users/preferences` - Update user preferences

### Logs
- `GET /api/logs/` - Get food consumption logs
- `POST /api/logs/` - Log food consumption

## Data Models

### Food
- Basic info: name, category, tags
- Nutrition: macros (protein, carbs, fat), calories
- Availability: areas, chains, price range

### User Preferences
- Diet style: omnivore, vegetarian, vegan, halal, keto
- Dislikes: list of disliked foods
- Budget: price range preference
- Home area: location for nearby recommendations

### Health Context
- Sleep hours: 0-12 hours
- Activity level: none, light, moderate, intense
- Mood/energy: low, normal, high

## Development Status

✅ **Completed:**
- Project structure setup
- Backend API with FastAPI
- Database models and schema
- Basic food recommendation logic
- RESTful API endpoints
- Frontend setup with React + TypeScript

🚧 **In Progress:**
- Frontend components and UI
- Advanced recommendation algorithms
- Maps integration
- Health data adapters

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details
