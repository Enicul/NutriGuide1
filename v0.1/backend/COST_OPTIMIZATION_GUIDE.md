# ChatGPT API Cost Optimization Guide

## Overview
This guide outlines strategies to minimize ChatGPT API costs while maintaining high-quality AI-powered features in the Spark food recommendation system.

## Current Implementation

### 1. Model Selection
- **Primary Model**: `gpt-3.5-turbo` (cheapest option)
- **Cost**: $0.0015/1K input tokens, $0.002/1K output tokens
- **Alternative**: `gpt-4` for complex analysis (10x more expensive)

### 2. Token Management
- **Max tokens per request**: 1000 (configurable)
- **Prompt truncation**: Automatic truncation for long prompts
- **Response limiting**: Structured JSON responses only

### 3. Cost Tracking
- Real-time token counting
- Cost estimation per request
- Usage statistics endpoint: `/api/foods/ai-usage-stats/`

## Optimization Strategies

### 1. Prompt Engineering
```python
# ✅ GOOD: Concise, structured prompts
prompt = f"""
Recommend {limit} foods for:
User: {diet_style}, budget {budget}
Health: {activity_level}, {sleep_hours}h sleep
Foods: {food_summary}

Return JSON: [{{"food_id": "id", "reason": "brief", "score": 0.9}}]
"""

# ❌ BAD: Verbose, unstructured prompts
prompt = f"""
Please analyze the user's dietary preferences and health context to provide 
comprehensive food recommendations that align with their nutritional goals...
"""
```

### 2. Response Caching
```python
# Cache common responses to avoid repeated API calls
@lru_cache(maxsize=100)
def get_cached_recommendations(user_hash: str, health_hash: str):
    # Only call API if not cached
    pass
```

### 3. Batch Processing
```python
# Process multiple requests together
async def batch_analyze_meals(meals: List[Meal]):
    # Single API call for multiple meals
    combined_prompt = create_batch_prompt(meals)
    response = await ai_service._call_chatgpt(combined_prompt)
    return parse_batch_response(response)
```

### 4. Fallback Systems
```python
# Always have fallback logic
try:
    ai_recommendations = await ai_service.get_recommendations(...)
except Exception:
    return fallback_recommendations()  # No API cost
```

## Cost Monitoring

### 1. Real-time Tracking
```python
# Monitor costs in real-time
usage_stats = ai_service.get_usage_stats()
print(f"Total cost: ${usage_stats['total_cost']:.4f}")
print(f"Tokens used: {usage_stats['total_tokens']}")
```

### 2. Daily Limits
```python
# Set daily cost limits
DAILY_COST_LIMIT = 5.0  # $5 per day
if ai_service.total_cost > DAILY_COST_LIMIT:
    disable_ai_features()
```

### 3. Usage Analytics
- Track most expensive endpoints
- Identify optimization opportunities
- Monitor cost per user

## Feature-Specific Optimizations

### 1. Food Recommendations
- **Cost**: ~$0.01-0.05 per request
- **Optimization**: Cache by user profile hash
- **Fallback**: Rule-based recommendations

### 2. Nutrition Analysis
- **Cost**: ~$0.02-0.08 per request
- **Optimization**: Batch multiple meals
- **Fallback**: Basic macro calculations

### 3. Meal Planning
- **Cost**: ~$0.05-0.15 per request
- **Optimization**: Template-based prompts
- **Fallback**: Pre-defined meal templates

## Implementation Examples

### 1. Smart Caching
```python
class CachedAIService:
    def __init__(self):
        self.cache = {}
        self.cache_ttl = 3600  # 1 hour
    
    async def get_recommendations(self, user_prefs, health_context):
        cache_key = self._generate_cache_key(user_prefs, health_context)
        
        if cache_key in self.cache:
            return self.cache[cache_key]
        
        result = await self._call_api(user_prefs, health_context)
        self.cache[cache_key] = result
        return result
```

### 2. Progressive Enhancement
```python
async def get_smart_recommendations(user_prefs, health_context):
    # Start with basic recommendations
    basic_recs = get_basic_recommendations(user_prefs, health_context)
    
    # Only use AI for complex cases
    if self._needs_ai_enhancement(user_prefs, health_context):
        ai_recs = await self._get_ai_recommendations(user_prefs, health_context)
        return merge_recommendations(basic_recs, ai_recs)
    
    return basic_recs
```

### 3. Cost-Aware Routing
```python
async def route_request(request_type, complexity):
    if complexity == "simple" and request_type in SIMPLE_CASES:
        return handle_simple_case(request_type)
    elif ai_service.total_cost < DAILY_BUDGET:
        return await handle_with_ai(request_type)
    else:
        return handle_with_fallback(request_type)
```

## Monitoring Dashboard

### Key Metrics
1. **Daily Cost**: Track spending per day
2. **Cost per User**: Average cost per user session
3. **API Success Rate**: Percentage of successful AI calls
4. **Fallback Usage**: How often fallbacks are used

### Alerts
- Daily cost exceeds $10
- API error rate > 10%
- Fallback usage > 50%

## Best Practices

### 1. Always Use Fallbacks
- Never rely solely on AI
- Implement rule-based alternatives
- Graceful degradation

### 2. Optimize Prompts
- Be specific and concise
- Use structured output formats
- Avoid redundant information

### 3. Cache Aggressively
- Cache by user profile
- Cache common responses
- Implement TTL for freshness

### 4. Monitor Continuously
- Track costs in real-time
- Set up alerts
- Regular optimization reviews

## Cost Estimation

### Typical Usage (100 users/day)
- Food recommendations: 200 calls × $0.03 = $6.00
- Nutrition analysis: 100 calls × $0.05 = $5.00
- Meal planning: 50 calls × $0.10 = $5.00
- **Total**: ~$16.00/day

### Optimized Usage (with caching)
- Food recommendations: 50 calls × $0.03 = $1.50
- Nutrition analysis: 30 calls × $0.05 = $1.50
- Meal planning: 20 calls × $0.10 = $2.00
- **Total**: ~$5.00/day (70% reduction)

## Emergency Procedures

### 1. Cost Overrun
```python
if ai_service.total_cost > EMERGENCY_LIMIT:
    # Disable AI features
    disable_ai_features()
    # Switch to fallback mode
    enable_fallback_mode()
    # Send alert
    send_cost_alert()
```

### 2. API Failures
```python
if api_error_rate > 0.1:
    # Increase fallback usage
    increase_fallback_weight()
    # Reduce AI call frequency
    reduce_ai_frequency()
```

This optimization strategy ensures the AI features remain cost-effective while providing high-quality recommendations to users.
