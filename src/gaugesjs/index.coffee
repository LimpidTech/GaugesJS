http = require 'https'
url = require 'url'

gauges_base_url = url.parse('https://secure.gaug.es')
gauges_default_token = process.env.GAUGES_TOKEN

this.client = (_options) ->
	options = _options or {}
	options.token = options.token or gauges_default_token

	if !options.token?
		callback 'A GAUGES_TOKEN environment variable or options.token must be
		          provided.'

	make_request = (_endpoint) ->
		endpoint = url.parse _endpoint
	
		request_data =
			hostname: endpoint.hostname
			path: endpoint.path
			headers:
				"X-Gauges-Token": options.token
	
		endpoint = (callback, opts) ->
			request = http.get request_data, (response) ->
				response.on 'data', (_data) ->
					data = JSON.parse(_data.toString('UTF-8'))
	
					callback 0, data
	
			request.on 'error', (err) ->
				callback err

	api =
		init: (callback) ->
			method = make_request gauges_base_url.href +  'me'

			method (err, data) ->
				for endpoint, complete_url of data.user.urls
					if endpoint == 'self'
						endpoint = 'me'

					api[endpoint] = make_request complete_url
			
				callback err, api

		make_request: make_request
