# MCP Toolbox Demo

A simple demonstration of the Google's "MCP Toolbox for Databases" with PostgreSQL for hotel management.

## Quick Demo Guide

This project demonstrates how to use the MCP Toolbox with a PostgreSQL database for basic hotel management operations.

Note: Replace `${TOOLBOX_PORT}` with the value set in `.env` file

### Setup

1. Start the services:
   ```
   cp .env.example .env
   docker compose up -d
   ```

2. The toolbox service will be available at `http://localhost:${TOOLBOX_PORT}`

### Demo Features

This demo includes a simple hotel database with tools to:

- Search hotels by name or location
- Book a hotel
- Update check-in/check-out dates
- Cancel a booking
- Ask the AI agent natural language questions about hotels (via MindsDB)

### How It Works

1. **Database**: A PostgreSQL database with a simple hotels table
2. **MCP Toolbox**: Provides SQL-based tools that connect to the database
3. **MindsDB**: Provides an AI agent (`hotel_agent`) for natural language queries
4. **Configuration**: Tools are defined in `config/tools.yaml`

### Available Demo Tools

- `search-hotels-by-name`: Find hotels by name (e.g., "Hilton")
- `search-hotels-by-location`: Find hotels by city (e.g., "Zurich")
- `book-hotel`: Book a hotel by ID
- `update-hotel`: Change check-in/check-out dates
- `cancel-hotel`: Cancel a booking
- `search-knowledge`: Ask the AI agent questions in natural language (e.g., "Are there any luxury hotels in Basel?")

### Example Usage

1. Search for hotels in Zurich:
   - Use the `search-hotels-by-location` tool
   - Parameter: location = "Zurich"

2. Book a hotel:
   - Use the `book-hotel` tool
   - Parameter: hotel_id = "2"

3. Update booking dates:
   - Use the `update-hotel` tool
   - Parameters: 
     - hotel_id = "2"
     - checkin_date = "2024-05-01"
     - checkout_date = "2024-05-05"

## Testing with MCP Inspector

### Connect to MCP Inspector

1. Run the MCP Inspector:
   ```
   npx @modelcontextprotocol/inspector
   ```
   Type `y` when it asks to install the inspector package.

2. It should show the following when the MCP Inspector is up and running:
   ```
   🔍 MCP Inspector is up and running at http://127.0.0.1:6274 🚀
   ```

3. Open the above link in your browser.

4. For Transport Type, select **Streamable HTTP**.

5. For URL, type in `http://127.0.0.1:${TOOLBOX_PORT}/mcp`.

6. Click **Connect**.

7. Select **List Tools**, you will see a list of tools configured in tools.yaml.

8. Test out your tools here!

## OpenWebUI Integration

In OpenWebUI, navigate to **Admin Panel > Settings > External Tools** and click **Add Connection**. Select **MCP Streamable HTTP** as the Type, and paste the toolbox `/mcp` URL as the Base URL, e.g. `http://<your-ip-with-port-or-domain>/mcp`.

> **Note:** OpenWebUI must be able to reach the toolbox. Use your machine's IP or a domain behind a reverse proxy. For local development, you can expose it temporarily with ngrok:
> ```
> ngrok http ${TOOLBOX_PORT}
> ```

## MindsDB Integration

MindsDB is included in the Docker Compose setup. It connects to the same PostgreSQL database and exposes an AI `hotel_agent` for natural language queries. The toolbox connects to MindsDB via the `search-knowledge` tool.

### Setup

1. Open the MindsDB editor at `http://localhost:47334`
2. Replace `OPENAI_API_KEY` in `mindsdb/create_knowledge_agent.sql` with your actual key
3. Run the SQL in the MindsDB editor — this creates the `psql_knowledge` DB connection and the `hotel_agent`

Once done, the `search-knowledge` tool in the MCP Toolbox will be ready to use.

### MindsDB MCP Server

MindsDB also exposes its own MCP server. Note that it currently only supports **SSE** (not Streamable HTTP), so use `/mcp/sse` as the endpoint:

```
http://localhost:47334/mcp/sse
```

A bearer token is required. See [MindsDB Authentication docs](https://docs.mindsdb.com/rest/authentication) to obtain one.

> **Note:** OpenWebUI only supports MCP Streamable HTTP, so the MindsDB MCP server (`/mcp/sse`) cannot be used directly with OpenWebUI. Use the MCP Toolbox (`/mcp`) instead.

### Example Queries (via MindsDB editor)

```sql
SELECT answer FROM hotel_agent WHERE question = 'What hotels are available in Zurich?';
SELECT answer FROM hotel_agent WHERE question = 'Show me luxury hotels';
SELECT answer FROM hotel_agent WHERE question = 'Is the Hilton Basel available?';
```

## Notes for the Team

This is a simple demonstration to show how the Google MCP Toolbox can be configured to work with a database. The SQL operations are basic but show the potential for more complex implementations.

## Links
- https://googleapis.github.io/genai-toolbox/getting-started/introduction/