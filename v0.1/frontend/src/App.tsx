import React, { useState, useEffect } from 'react'
import './App.css'

// Types
interface Food {
  id: string
  name: string
  category: string
  tags: string[]
  macros: {
    protein_g: number
    carbs_g: number
    fat_g: number
  }
  kcal: number
  availability: {
    areas: string[]
    chains: string[]
  }
  est_price_range: string
}

interface Recommendation {
  user_pref: {
    diet_style: string
    dislikes: string[]
    budget: string
    home_area: string | null
  }
  health_context: {
    sleep_hours: number
    activity_level: string
    mood_energy: string
  }
  limit: number
}

interface MealAnalysis {
  foods: Array<{
    food_id: string
    quantity: number
  }>
  meal_type: string
}

const API_BASE = 'http://localhost:8000'

function App() {
  const [foods, setFoods] = useState<Food[]>([])
  const [recommendations, setRecommendations] = useState<Food[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState<'foods' | 'recommendations' | 'analysis'>('foods')
  
  // Recommendation form state
  const [recForm, setRecForm] = useState<Recommendation>({
    user_pref: {
      diet_style: 'omnivore',
      dislikes: [],
      budget: '$$',
      home_area: 'downtown'
    },
    health_context: {
      sleep_hours: 8,
      activity_level: 'moderate',
      mood_energy: 'normal'
    },
    limit: 5
  })
  
  // Meal analysis form state
  const [mealForm, setMealForm] = useState<MealAnalysis>({
    foods: [{ food_id: 'food_001', quantity: 1.0 }],
    meal_type: 'breakfast'
  })
  
  const [analysisResult, setAnalysisResult] = useState<any>(null)

  // Load all foods on component mount
  useEffect(() => {
    loadFoods()
  }, [])

  const loadFoods = async () => {
    try {
      setLoading(true)
      setError(null)
      const response = await fetch(`${API_BASE}/api/foods/`)
      if (!response.ok) throw new Error('Failed to load foods')
      const data = await response.json()
      setFoods(data)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }

  const getRecommendations = async () => {
    try {
      setLoading(true)
      setError(null)
      const response = await fetch(`${API_BASE}/api/foods/recommend/`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(recForm)
      })
      if (!response.ok) throw new Error('Failed to get recommendations')
      const data = await response.json()
      setRecommendations(data)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }

  const analyzeMeal = async () => {
    try {
      setLoading(true)
      setError(null)
      const response = await fetch(`${API_BASE}/api/foods/analyze-meal/`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(mealForm)
      })
      if (!response.ok) throw new Error('Failed to analyze meal')
      const data = await response.json()
      setAnalysisResult(data)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }

  const addFoodToMeal = () => {
    setMealForm(prev => ({
      ...prev,
      foods: [...prev.foods, { food_id: 'food_001', quantity: 1.0 }]
    }))
  }

  const removeFoodFromMeal = (index: number) => {
    setMealForm(prev => ({
      ...prev,
      foods: prev.foods.filter((_, i) => i !== index)
    }))
  }

  const updateMealFood = (index: number, field: 'food_id' | 'quantity', value: string | number) => {
    setMealForm(prev => ({
      ...prev,
      foods: prev.foods.map((food, i) => 
        i === index ? { ...food, [field]: value } : food
      )
    }))
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <h1 className="text-2xl font-bold text-gray-900">🍎 Spark Food Recommendation</h1>
            <div className="flex space-x-4">
              <button
                onClick={() => setActiveTab('foods')}
                className={`px-4 py-2 rounded-md ${
                  activeTab === 'foods' 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                }`}
              >
                All Foods
              </button>
              <button
                onClick={() => setActiveTab('recommendations')}
                className={`px-4 py-2 rounded-md ${
                  activeTab === 'recommendations' 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                }`}
              >
                Recommendations
              </button>
              <button
                onClick={() => setActiveTab('analysis')}
                className={`px-4 py-2 rounded-md ${
                  activeTab === 'analysis' 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                }`}
              >
                Meal Analysis
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {error && (
          <div className="mb-6 bg-red-50 border border-red-200 rounded-md p-4">
            <div className="flex">
              <div className="ml-3">
                <h3 className="text-sm font-medium text-red-800">Error</h3>
                <div className="mt-2 text-sm text-red-700">{error}</div>
              </div>
            </div>
          </div>
        )}

        {loading && (
          <div className="mb-6 bg-blue-50 border border-blue-200 rounded-md p-4">
            <div className="flex">
              <div className="ml-3">
                <h3 className="text-sm font-medium text-blue-800">Loading...</h3>
                <div className="mt-2 text-sm text-blue-700">Please wait while we process your request.</div>
              </div>
            </div>
          </div>
        )}

        {/* All Foods Tab */}
        {activeTab === 'foods' && (
          <div>
            <h2 className="text-xl font-semibold mb-4">All Available Foods</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {foods.map((food) => (
                <div key={food.id} className="bg-white rounded-lg shadow-md p-6">
                  <h3 className="text-lg font-semibold text-gray-900">{food.name}</h3>
                  <p className="text-sm text-gray-600 capitalize">{food.category}</p>
                  <div className="mt-2">
                    <span className="inline-block bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full mr-2">
                      {food.kcal} kcal
                    </span>
                    <span className="inline-block bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">
                      {food.est_price_range}
                    </span>
                  </div>
                  <div className="mt-3 text-sm text-gray-600">
                    <p>Protein: {food.macros.protein_g}g</p>
                    <p>Carbs: {food.macros.carbs_g}g</p>
                    <p>Fat: {food.macros.fat_g}g</p>
                  </div>
                  <div className="mt-2">
                    {food.tags.map((tag) => (
                      <span key={tag} className="inline-block bg-gray-100 text-gray-700 text-xs px-2 py-1 rounded mr-1 mb-1">
                        {tag}
                      </span>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Recommendations Tab */}
        {activeTab === 'recommendations' && (
          <div>
            <h2 className="text-xl font-semibold mb-4">Get Personalized Recommendations</h2>
            
            {/* Recommendation Form */}
            <div className="bg-white rounded-lg shadow-md p-6 mb-6">
              <h3 className="text-lg font-semibold mb-4">Your Preferences</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Diet Style</label>
                  <select
                    value={recForm.user_pref.diet_style}
                    onChange={(e) => setRecForm(prev => ({
                      ...prev,
                      user_pref: { ...prev.user_pref, diet_style: e.target.value }
                    }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="omnivore">Omnivore</option>
                    <option value="vegetarian">Vegetarian</option>
                    <option value="vegan">Vegan</option>
                    <option value="keto">Keto</option>
                  </select>
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Budget</label>
                  <select
                    value={recForm.user_pref.budget}
                    onChange={(e) => setRecForm(prev => ({
                      ...prev,
                      user_pref: { ...prev.user_pref, budget: e.target.value }
                    }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="$">$ (Budget)</option>
                    <option value="$$">$$ (Moderate)</option>
                    <option value="$$$">$$$ (Premium)</option>
                  </select>
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Activity Level</label>
                  <select
                    value={recForm.health_context.activity_level}
                    onChange={(e) => setRecForm(prev => ({
                      ...prev,
                      health_context: { ...prev.health_context, activity_level: e.target.value }
                    }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  >
                    <option value="low">Low</option>
                    <option value="moderate">Moderate</option>
                    <option value="high">High</option>
                    <option value="very_high">Very High</option>
                  </select>
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Sleep Hours</label>
                  <input
                    type="number"
                    min="4"
                    max="12"
                    step="0.5"
                    value={recForm.health_context.sleep_hours}
                    onChange={(e) => setRecForm(prev => ({
                      ...prev,
                      health_context: { ...prev.health_context, sleep_hours: parseFloat(e.target.value) }
                    }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
              </div>
              
              <button
                onClick={getRecommendations}
                className="mt-4 bg-blue-500 text-white px-6 py-2 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                Get Recommendations
              </button>
            </div>

            {/* Recommendations Results */}
            {recommendations.length > 0 && (
              <div>
                <h3 className="text-lg font-semibold mb-4">Recommended Foods</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {recommendations.map((food) => (
                    <div key={food.id} className="bg-white rounded-lg shadow-md p-6 border-l-4 border-blue-500">
                      <h4 className="text-lg font-semibold text-gray-900">{food.name}</h4>
                      <p className="text-sm text-gray-600 capitalize">{food.category}</p>
                      <div className="mt-2">
                        <span className="inline-block bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full mr-2">
                          {food.kcal} kcal
                        </span>
                        <span className="inline-block bg-green-100 text-green-800 text-xs px-2 py-1 rounded-full">
                          {food.est_price_range}
                        </span>
                      </div>
                      <div className="mt-3 text-sm text-gray-600">
                        <p>Protein: {food.macros.protein_g}g</p>
                        <p>Carbs: {food.macros.carbs_g}g</p>
                        <p>Fat: {food.macros.fat_g}g</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}

        {/* Meal Analysis Tab */}
        {activeTab === 'analysis' && (
      <div>
            <h2 className="text-xl font-semibold mb-4">Analyze Your Meal</h2>
            
            {/* Meal Analysis Form */}
            <div className="bg-white rounded-lg shadow-md p-6 mb-6">
              <h3 className="text-lg font-semibold mb-4">Meal Composition</h3>
              
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">Meal Type</label>
                <select
                  value={mealForm.meal_type}
                  onChange={(e) => setMealForm(prev => ({ ...prev, meal_type: e.target.value }))}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="breakfast">Breakfast</option>
                  <option value="lunch">Lunch</option>
                  <option value="dinner">Dinner</option>
                  <option value="snack">Snack</option>
                </select>
              </div>
              
              <div className="space-y-4">
                {mealForm.foods.map((food, index) => (
                  <div key={index} className="flex items-center space-x-4 p-4 border border-gray-200 rounded-md">
                    <div className="flex-1">
                      <label className="block text-sm font-medium text-gray-700 mb-1">Food</label>
                      <select
                        value={food.food_id}
                        onChange={(e) => updateMealFood(index, 'food_id', e.target.value)}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      >
                        {foods.map((f) => (
                          <option key={f.id} value={f.id}>{f.name}</option>
                        ))}
                      </select>
                    </div>
                    <div className="w-24">
                      <label className="block text-sm font-medium text-gray-700 mb-1">Quantity</label>
                      <input
                        type="number"
                        min="0.1"
                        max="10"
                        step="0.1"
                        value={food.quantity}
                        onChange={(e) => updateMealFood(index, 'quantity', parseFloat(e.target.value))}
                        className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    <button
                      onClick={() => removeFoodFromMeal(index)}
                      className="px-3 py-2 bg-red-500 text-white rounded-md hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-500"
                    >
                      Remove
                    </button>
                  </div>
                ))}
                
                <button
                  onClick={addFoodToMeal}
                  className="w-full px-4 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500"
                >
                  + Add Food
                </button>
      </div>
              
              <button
                onClick={analyzeMeal}
                className="mt-4 bg-green-500 text-white px-6 py-2 rounded-md hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-green-500"
              >
                Analyze Meal
        </button>
            </div>

            {/* Analysis Results */}
            {analysisResult && (
              <div className="bg-white rounded-lg shadow-md p-6">
                <h3 className="text-lg font-semibold mb-4">Analysis Results</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <h4 className="font-semibold text-gray-900 mb-2">Nutrition Summary</h4>
                    <div className="space-y-2">
                      <div className="flex justify-between">
                        <span>Total Calories:</span>
                        <span className="font-semibold">{analysisResult.total_calories}</span>
                      </div>
                      <div className="flex justify-between">
                        <span>Protein:</span>
                        <span className="font-semibold">{analysisResult.total_protein}g</span>
                      </div>
                      <div className="flex justify-between">
                        <span>Carbs:</span>
                        <span className="font-semibold">{analysisResult.total_carbs}g</span>
                      </div>
                      <div className="flex justify-between">
                        <span>Fat:</span>
                        <span className="font-semibold">{analysisResult.total_fat}g</span>
                      </div>
                    </div>
                  </div>
                  <div>
                    <h4 className="font-semibold text-gray-900 mb-2">Balance Score</h4>
                    <div className="text-3xl font-bold text-blue-600">
                      {analysisResult.balance_score}/10
                    </div>
                    <p className="text-sm text-gray-600 mt-2">
                      {analysisResult.balance_score >= 8 ? 'Excellent balance!' : 
                       analysisResult.balance_score >= 6 ? 'Good balance' : 
                       'Could be improved'}
        </p>
      </div>
                </div>
                
                {analysisResult.suggestions && analysisResult.suggestions.length > 0 && (
                  <div className="mt-6">
                    <h4 className="font-semibold text-gray-900 mb-2">Suggestions</h4>
                    <ul className="list-disc list-inside space-y-1 text-sm text-gray-700">
                      {analysisResult.suggestions.map((suggestion: string, index: number) => (
                        <li key={index}>{suggestion}</li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            )}
          </div>
        )}
      </main>
    </div>
  )
}

export default App