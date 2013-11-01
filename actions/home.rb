require 'net/http'
module LocBox
	# https://www.airbnb.com/search/ajax_get_results?search_view=1&min_bedrooms=0&min_bathrooms=0&min_beds=0&page=1&location=Raleigh%2C+NC&checkin=05%2F01%2F2013&checkout=05%2F12%2F2013&guests=1&sort=0&keywords=&price_min=&price_max=&per_page=21


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

		get '/lookup' do
			bnb_url = 'https://www.airbnb.com/search/ajax_get_results?search_view=1&min_bedrooms=0&min_bathrooms=0&min_beds=0&page=1&location=Raleigh%2C+NC&checkin=05%2F01%2F2013&checkout=05%2F12%2F2013&guests=1&sort=0&keywords=&price_min=&price_max=&per_page=21'
			bnb_url = 'https://www.airbnb.com/search/ajax_get_results'
			bnbParams = {
				'search_view' => 1,
				'min_bedrooms' => 0,
				'min_bathrooms' => 0,
				'min_beds' => 0,
				'page' => 0,
				'location' => params['city'],
				'checkin' => Date.today,
				'checkout' => Date.today+7,
				'guests' => 1,
				'sort' => 0,
				'per_page' => 21
				}

			bnb_uri = URI.parse(bnb_url)

			bnb_uri.query = URI.encode_www_form(bnbParams)

			bnbResponse = Net::HTTP.get_response(bnb_uri)

			@result = JSON.parse(bnbResponse.body)

			haml :lookup
		end
	end
end