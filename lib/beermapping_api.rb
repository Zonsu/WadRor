class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 60.seconds) { fetch_places_in(city) }
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.key
    raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
    ENV['APIKEY']
  end

  def self.place_info(name)
  url = "http://beermapping.com/webservice/locquery/#{self.key}/"
  response = HTTParty.get "#{url}#{ERB::Util.url_encode(name)}"

  place = response.parsed_response['bmp_locations']['location']

    return nil if place.is_a?(Hash) and place['id'].nil?

    Place.new(place)


  end
end