# Implementation Guidelines for Non-AI Tasks

## Overview
This document provides detailed guidelines for implementing the remaining features in the Spark food recommendation system that cannot be handled by ChatGPT API.

## 1. Frontend Development (React + TypeScript)

### 1.1 Component Architecture
```
src/
├── components/
│   ├── common/           # Reusable UI components
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Card.tsx
│   │   └── Modal.tsx
│   ├── food/             # Food-related components
│   │   ├── FoodCard.tsx
│   │   ├── FoodList.tsx
│   │   ├── FoodDetails.tsx
│   │   └── RecommendationCard.tsx
│   ├── nutrition/        # Nutrition components
│   │   ├── NutritionChart.tsx
│   │   ├── MacroBreakdown.tsx
│   │   └── BalanceScore.tsx
│   └── layout/           # Layout components
│       ├── Header.tsx
│       ├── Sidebar.tsx
│       └── Footer.tsx
├── pages/                # Page components
│   ├── Home.tsx
│   ├── Recommendations.tsx
│   ├── Profile.tsx
│   ├── Logs.tsx
│   └── Settings.tsx
├── stores/               # Zustand state management
│   ├── foodStore.ts
│   ├── userStore.ts
│   └── nutritionStore.ts
└── types/                # TypeScript definitions
    ├── food.ts
    ├── user.ts
    └── api.ts
```

### 1.2 State Management with Zustand
```typescript
// stores/foodStore.ts
import { create } from 'zustand'

interface FoodStore {
  foods: Food[]
  recommendations: Food[]
  selectedFood: Food | null
  loading: boolean
  error: string | null
  
  // Actions
  fetchFoods: () => Promise<void>
  getRecommendations: (prefs: UserPrefs, health: HealthContext) => Promise<void>
  selectFood: (food: Food) => void
  clearError: () => void
}

export const useFoodStore = create<FoodStore>((set, get) => ({
  foods: [],
  recommendations: [],
  selectedFood: null,
  loading: false,
  error: null,
  
  fetchFoods: async () => {
    set({ loading: true, error: null })
    try {
      const response = await fetch('/api/foods/')
      const foods = await response.json()
      set({ foods, loading: false })
    } catch (error) {
      set({ error: error.message, loading: false })
    }
  },
  
  getRecommendations: async (prefs, health) => {
    set({ loading: true })
    try {
      const response = await fetch('/api/foods/recommend/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user_pref: prefs, health_context: health })
      })
      const recommendations = await response.json()
      set({ recommendations, loading: false })
    } catch (error) {
      set({ error: error.message, loading: false })
    }
  },
  
  selectFood: (food) => set({ selectedFood: food }),
  clearError: () => set({ error: null })
}))
```

### 1.3 API Integration
```typescript
// services/api.ts
class ApiService {
  private baseUrl = 'http://localhost:8000/api'
  
  async get<T>(endpoint: string): Promise<T> {
    const response = await fetch(`${this.baseUrl}${endpoint}`)
    if (!response.ok) throw new Error(`API Error: ${response.status}`)
    return response.json()
  }
  
  async post<T>(endpoint: string, data: any): Promise<T> {
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
    if (!response.ok) throw new Error(`API Error: ${response.status}`)
    return response.json()
  }
}

export const apiService = new ApiService()
```

## 2. Maps Integration (Google Maps Places API)

### 2.1 Setup
```typescript
// services/mapsService.ts
interface MapsConfig {
  apiKey: string
  libraries: string[]
  center: { lat: number; lng: number }
  zoom: number
}

class MapsService {
  private map: google.maps.Map | null = null
  private placesService: google.maps.places.PlacesService | null = null
  
  async initializeMap(containerId: string, config: MapsConfig) {
    const map = new google.maps.Map(
      document.getElementById(containerId) as HTMLElement,
      {
        center: config.center,
        zoom: config.zoom,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }
    )
    
    this.map = map
    this.placesService = new google.maps.places.PlacesService(map)
  }
  
  async findNearbyRestaurants(location: { lat: number; lng: number }, radius: number = 1000) {
    if (!this.placesService) throw new Error('Maps not initialized')
    
    return new Promise<google.maps.places.PlaceResult[]>((resolve, reject) => {
      this.placesService!.nearbySearch({
        location,
        radius,
        type: 'restaurant'
      }, (results, status) => {
        if (status === google.maps.places.PlacesServiceStatus.OK) {
          resolve(results || [])
        } else {
          reject(new Error(`Places API error: ${status}`))
        }
      })
    })
  }
}

export const mapsService = new MapsService()
```

### 2.2 React Component
```typescript
// components/MapsComponent.tsx
import React, { useEffect, useRef } from 'react'
import { mapsService } from '../services/mapsService'

interface MapsComponentProps {
  onRestaurantSelect: (restaurant: google.maps.places.PlaceResult) => void
  userLocation?: { lat: number; lng: number }
}

export const MapsComponent: React.FC<MapsComponentProps> = ({ 
  onRestaurantSelect, 
  userLocation 
}) => {
  const mapRef = useRef<HTMLDivElement>(null)
  
  useEffect(() => {
    if (mapRef.current && userLocation) {
      mapsService.initializeMap('map', {
        apiKey: process.env.REACT_APP_GOOGLE_MAPS_API_KEY!,
        libraries: ['places'],
        center: userLocation,
        zoom: 15
      })
    }
  }, [userLocation])
  
  return (
    <div className="w-full h-96">
      <div ref={mapRef} id="map" className="w-full h-full rounded-lg" />
    </div>
  )
}
```

## 3. Health Data Adapters

### 3.1 HealthKit Adapter (iOS)
```typescript
// adapters/healthKitAdapter.ts
interface HealthKitData {
  steps: number
  caloriesBurned: number
  heartRate: number
  sleepHours: number
  activeMinutes: number
}

class HealthKitAdapter {
  async requestPermissions(): Promise<boolean> {
    // Request HealthKit permissions
    return new Promise((resolve) => {
      if (window.HealthKit) {
        window.HealthKit.requestAuthorization({
          read: ['steps', 'activeEnergyBurned', 'heartRate', 'sleepAnalysis'],
          write: []
        }, (success: boolean) => {
          resolve(success)
        })
      } else {
        resolve(false)
      }
    })
  }
  
  async getTodayData(): Promise<HealthKitData> {
    return new Promise((resolve) => {
      if (window.HealthKit) {
        window.HealthKit.getTodayData((data: HealthKitData) => {
          resolve(data)
        })
      } else {
        // Mock data for development
        resolve({
          steps: 8000,
          caloriesBurned: 400,
          heartRate: 72,
          sleepHours: 7.5,
          activeMinutes: 45
        })
      }
    })
  }
}

export const healthKitAdapter = new HealthKitAdapter()
```

### 3.2 Google Fit Adapter
```typescript
// adapters/googleFitAdapter.ts
class GoogleFitAdapter {
  private client: any
  
  async initialize() {
    // Initialize Google Fit API client
    this.client = await gapi.client.init({
      apiKey: process.env.REACT_APP_GOOGLE_FIT_API_KEY,
      discoveryDocs: ['https://www.googleapis.com/discovery/v1/apis/fitness/v1/rest']
    })
  }
  
  async getTodayData(): Promise<HealthKitData> {
    const today = new Date()
    const startTime = new Date(today.getFullYear(), today.getMonth(), today.getDate())
    const endTime = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1)
    
    const response = await this.client.fitness.users.dataset.aggregate({
      userId: 'me',
      requestBody: {
        aggregateBy: [
          { dataTypeName: 'com.google.step_count.delta' },
          { dataTypeName: 'com.google.calories.expended' },
          { dataTypeName: 'com.google.heart_rate.bpm' }
        ],
        bucketByTime: { durationMillis: 86400000 },
        startTimeMillis: startTime.getTime(),
        endTimeMillis: endTime.getTime()
      }
    })
    
    return this.parseGoogleFitData(response.result)
  }
  
  private parseGoogleFitData(data: any): HealthKitData {
    // Parse Google Fit response into standardized format
    return {
      steps: data.bucket[0]?.dataset[0]?.point[0]?.value[0]?.intVal || 0,
      caloriesBurned: data.bucket[0]?.dataset[1]?.point[0]?.value[0]?.fpVal || 0,
      heartRate: data.bucket[0]?.dataset[2]?.point[0]?.value[0]?.fpVal || 0,
      sleepHours: 0, // Not available in basic Google Fit
      activeMinutes: 0
    }
  }
}

export const googleFitAdapter = new GoogleFitAdapter()
```

## 4. Testing Strategy

### 4.1 Unit Tests (Jest + React Testing Library)
```typescript
// __tests__/FoodCard.test.tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { FoodCard } from '../components/food/FoodCard'

const mockFood = {
  id: 'food_001',
  name: 'Chicken Teriyaki Bowl',
  kcal: 420,
  macros: { protein_g: 35, carbs_g: 45, fat_g: 12 }
}

describe('FoodCard', () => {
  it('renders food information correctly', () => {
    render(<FoodCard food={mockFood} onSelect={jest.fn()} />)
    
    expect(screen.getByText('Chicken Teriyaki Bowl')).toBeInTheDocument()
    expect(screen.getByText('420 kcal')).toBeInTheDocument()
    expect(screen.getByText('35g protein')).toBeInTheDocument()
  })
  
  it('calls onSelect when clicked', () => {
    const mockOnSelect = jest.fn()
    render(<FoodCard food={mockFood} onSelect={mockOnSelect} />)
    
    fireEvent.click(screen.getByRole('button'))
    expect(mockOnSelect).toHaveBeenCalledWith(mockFood)
  })
})
```

### 4.2 API Tests (Pytest)
```python
# tests/test_api.py
import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_get_foods():
    response = client.get("/api/foods/")
    assert response.status_code == 200
    assert len(response.json()) > 0

def test_get_recommendations():
    response = client.post("/api/foods/recommend/", json={
        "user_pref": {
            "diet_style": "omnivore",
            "dislikes": [],
            "budget": "$$"
        },
        "health_context": {
            "sleep_hours": 8,
            "activity_level": "moderate",
            "mood_energy": "normal"
        }
    })
    assert response.status_code == 200
    assert len(response.json()) > 0
```

## 5. Performance Optimization

### 5.1 Frontend Optimization
```typescript
// Use React.memo for expensive components
export const FoodCard = React.memo(({ food, onSelect }: FoodCardProps) => {
  // Component implementation
})

// Use useMemo for expensive calculations
const expensiveCalculation = useMemo(() => {
  return foods.filter(food => food.kcal > 300).sort((a, b) => b.kcal - a.kcal)
}, [foods])

// Use useCallback for event handlers
const handleFoodSelect = useCallback((food: Food) => {
  onSelect(food)
}, [onSelect])
```

### 5.2 Backend Optimization
```python
# Use database indexes
CREATE INDEX idx_foods_protein ON foods(protein_g);
CREATE INDEX idx_foods_calories ON foods(kcal);
CREATE INDEX idx_foods_category ON foods(category);

# Use connection pooling
from sqlalchemy.pool import QueuePool

engine = create_engine(
    DATABASE_URL,
    poolclass=QueuePool,
    pool_size=10,
    max_overflow=20
)

# Cache frequently accessed data
from functools import lru_cache

@lru_cache(maxsize=100)
def get_food_by_id(food_id: str):
    # Database query
    pass
```

## 6. Deployment Strategy

### 6.1 Frontend Deployment (Vercel/Netlify)
```json
// vercel.json
{
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "dist"
      }
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ]
}
```

### 6.2 Backend Deployment (Railway/Heroku)
```yaml
# railway.toml
[build]
builder = "nixpacks"

[deploy]
startCommand = "uvicorn main:app --host 0.0.0.0 --port $PORT"
healthcheckPath = "/health"
healthcheckTimeout = 100
restartPolicyType = "on_failure"
```

## 7. Monitoring and Analytics

### 7.1 Error Tracking (Sentry)
```typescript
// Initialize Sentry
import * as Sentry from "@sentry/react"

Sentry.init({
  dsn: process.env.REACT_APP_SENTRY_DSN,
  environment: process.env.NODE_ENV
})

// Track errors
try {
  await apiService.getRecommendations(userPrefs, healthContext)
} catch (error) {
  Sentry.captureException(error)
  throw error
}
```

### 7.2 Analytics (Google Analytics)
```typescript
// Track user interactions
import { trackEvent } from './analytics'

const handleFoodSelect = (food: Food) => {
  trackEvent('food_selected', {
    food_id: food.id,
    food_name: food.name,
    category: food.category
  })
  onSelect(food)
}
```

## 8. Security Considerations

### 8.1 API Security
```python
# Rate limiting
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter

@app.post("/api/foods/recommend/")
@limiter.limit("10/minute")
async def recommend_foods(request: Request, ...):
    # Endpoint implementation
    pass
```

### 8.2 Frontend Security
```typescript
// Sanitize user input
import DOMPurify from 'dompurify'

const sanitizeInput = (input: string): string => {
  return DOMPurify.sanitize(input)
}

// Validate API responses
const validateFood = (data: any): Food | null => {
  try {
    return FoodSchema.parse(data)
  } catch {
    return null
  }
}
```

## 9. Development Workflow

### 9.1 Git Workflow
```bash
# Feature branch workflow
git checkout -b feature/nutrition-charts
git add .
git commit -m "Add nutrition charts component"
git push origin feature/nutrition-charts
# Create pull request
```

### 9.2 Code Quality
```json
// .eslintrc.json
{
  "extends": ["@typescript-eslint/recommended", "prettier"],
  "rules": {
    "no-unused-vars": "error",
    "prefer-const": "error",
    "@typescript-eslint/no-explicit-any": "warn"
  }
}
```

This comprehensive guide provides the roadmap for implementing all remaining features in the Spark food recommendation system, ensuring a robust, scalable, and maintainable application.
