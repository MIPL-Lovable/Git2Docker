import { useState } from 'react'
import './App.css'

interface WeatherForecast {
  date: string;
  temperatureC: number;
  temperatureF: number;
  summary?: string;
}

function App() {
  const [forecast, setForecast] = useState<WeatherForecast[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchWeather = async () => {
    setLoading(true);
    try {
      const response = await fetch('/api/weatherforecast');
      const data = await response.json();
      setForecast(data);
    } catch (error) {
      console.error('Error fetching weather:', error);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="App">
      <div className="container">
        <h1>React + ASP.NET Core API</h1>
        <p>This is a React application connected to an ASP.NET Core Web API.</p>
        
        <div className="api-section">
          <h2>Weather Forecast</h2>
          <button onClick={fetchWeather} disabled={loading}>
            {loading ? 'Loading...' : 'Get Weather Forecast'}
          </button>
          
          {forecast.length > 0 && (
            <div className="forecast-results">
              <h3>Forecast Results:</h3>
              <ul>
                {forecast.map((item, index) => (
                  <li key={index}>
                    <strong>{item.date}</strong>: {item.temperatureC}°C ({item.temperatureF}°F) - {item.summary}
                  </li>
                ))}
              </ul>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default App