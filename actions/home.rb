require 'net/http'
module LocBox

	class AirBnB < Sinatra::Base
		helpers do
		  def h(text)
		    Rack::Utils.escape_html(text)
		  end
		end

		# include HTTParty
		get '/' do
			haml :home
		end

		def get_for_date(date)
			bnb_url = 'https://www.airbnb.com/search/ajax_get_results'
			bnbParams = {
				'search_view' => 1,
				'min_bedrooms' => 0,
				'min_bathrooms' => 0,
				'min_beds' => 0,
				'page' => 0,
				'location' => params['city'],
				'checkin' => date,
				'checkout' => date+1,
				'guests' => 1,
				'sort' => 0,
				'per_page' => 21
				}

			bnb_uri = URI.parse(bnb_url)

			bnb_uri.query = URI.encode_www_form(bnbParams)

			bnbResponse = Net::HTTP.get_response(bnb_uri)

			JSON.parse(bnbResponse.body)
		end

		get '/lookup' do
			@results = []

			7.times do |i|
				@results[i] = get_for_date(Date.today + i)['properties'].map { |prop| prop['name']}
			end

			@properties = @results.flatten.map(&:strip).uniq.sort

			haml :lookup
		end
	end
end