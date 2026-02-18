-- ============================================
-- MindsDB Hotel Booking Agent
-- ============================================
-- This agent connects to PostgreSQL and answers questions about hotel availability,
-- locations, and pricing using the hotels table:
-- - hotels: id, name, location, price_tier, checkin_date, checkout_date, booked

-- ============================================
-- 1. Create Database Connection to PostgreSQL
-- ============================================
CREATE DATABASE psql_knowledge
WITH ENGINE = 'postgres',
PARAMETERS = {
  "host": "db",
  "port": "5432",
  "database": "toolbox_db",
  "user": "toolbox_user",
  "password": "my-password",
  "schema": "public"
};

-- ============================================
-- 2. Create Hotel Booking Agent
-- ============================================
CREATE AGENT hotel_agent
USING
  model = {
    "provider": "openai",
    "model_name": "openai/gpt-4o",
    "api_key": "OPENAI_API_KEY",
    "base_url": "https://models.thcloud.ai"
  },
  data = {
    "tables": [
      "psql_knowledge.hotels"
    ]
  },
  prompt_template = '
You are a helpful hotel booking assistant. Use the hotels table to answer questions about availability, locations, and pricing.

Table columns: id, name, location, price_tier, checkin_date, checkout_date, booked (0 = available, 1 = booked).
Price tiers from low to high: Midscale, Upper Midscale, Upscale, Upper Upscale, Luxury.

Always query the database before answering. Only recommend hotels where booked = 0.
Respond in the same language as the user.
';

-- ============================================
-- Usage Examples (Commented Out)
-- ============================================

-- Example 1: List all available hotels
-- SELECT answer FROM hotel_agent
-- WHERE question = 'What hotels are available?';

-- Example 2: Search by location
-- SELECT answer FROM hotel_agent
-- WHERE question = 'Show me hotels in Zurich';

-- Example 3: Search by budget
-- SELECT answer FROM hotel_agent
-- WHERE question = 'What luxury hotels do you have?';

-- Example 4: Check specific hotel availability
-- SELECT answer FROM hotel_agent
-- WHERE question = 'Is the Hilton Basel available?';

-- Example 5: Available hotels in a city
-- SELECT answer FROM hotel_agent
-- WHERE question = 'Are there any available hotels in Basel?';

-- Example 6: Budget-friendly options
-- SELECT answer FROM hotel_agent
-- WHERE question = 'What are your most affordable hotels?';

-- ============================================
-- Notes
-- ============================================

-- The agent will automatically:
-- 1. Query the hotels table based on the user''s question
-- 2. Filter by location, price_tier, or availability (booked = 0)
-- 3. Return natural language answers with hotel details

-- Schema: hotels(id, name, location, price_tier, checkin_date, checkout_date, booked)

-- Locations: Basel, Zurich, Lucerne, Bern, Geneva
-- Price Tiers (low to high): Midscale, Upper Midscale, Upscale, Upper Upscale, Luxury