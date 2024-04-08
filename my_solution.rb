require "http"
require "json"

# Ask the user for their location
puts "Will you need an umbrella today?"
puts "Where are you?"

# Get and store the user’s location
user_location = gets.chomp

# Get the user’s latitude and longitude from the Google Maps API
gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"
raw_gmaps = HTTP.get(gmaps_url)

parsed_gmaps = JSON.parse(raw_gmaps)
results_gmaps = parsed_gmaps.fetch("results")
first_result_hash = results_gmaps.at(0)
geometry_hash = first_result_hash.fetch("geometry")
location_hash = geometry_hash.fetch("location")
latitude = location_hash.fetch("lat")
longitude = location_hash.fetch("lng")
puts "The coordinates are lat: #{latitude} and long: #{longitude}."

# Get the weather at the user’s coordinates from the Pirate Weather API
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"
raw_pirate_weather = HTTP.get(pirate_weather_url)
parsed_pirate_weather = JSON.parse(raw_pirate_weather)
currently_hash = parsed_pirate_weather.fetch("currently")
currently_temp = currently_hash.fetch("temperature")
puts "It is currently #{currently_temp}°F."

# Display the current temperature and summary of the weather for the next hour
minutely_hash = parsed_pirate_weather.fetch("minutely")

if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary", false)

  puts "Next hour: #{next_hour_summary}"
end
