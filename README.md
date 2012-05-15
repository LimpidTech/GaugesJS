gauges.js
=========

Exposing the gauges API to NodeJS - one endpoint at a time. Maybe two.

Advanced Usage
-----

### Initializing the API
Initialize the gauges API. This part might seem a bit unnecessary, but it is
required for GaugesJS to learn Gauges endpoints. Instead of hard-coding them,
GaugesJS reads the gauges API and exposes them as necessary.

    var gauges = require('gaugesjs'),
        client = gaugesjs.client();

    client.init(function get_api(err, api) {
      # The `api` object is what we use to access the Gauges API.
      # After this is called, endpoints are also accessible as `client.api`.
    });

Normally, GaugesJS will look for an environment variable called GAUGES_TOKEN.
In order to get your authenticatino token. If you prefer to provide this via
any other means, you may also pass it as an option to the client function.

    var gauges = require('gaugesjs'),
        client = gauges.client({
          token: '...'
        });

### Listing your gauges

After initializing the API's endpoints, you can get a list of your gauges
like this:

    var gaugesjs = require('gaugesjs'),
        client = gaugesjs.client();

    client.init(function get_api(err, api) {
      api.gauges(function get_gauges(err, gauges) {
        # The `gauges` variable now contains a list of your gauges.
      })
    });


### Listing your clients

After initializing the API's endpoints, you can get a list of your API
clients like this:

    var gaugesjs = require('gaugesjs'),
        client = gaugesjs.client();

    client.init(function get_api(err, api) {
      api.clients(function get_clients(err, clients) {
        # The `clients` variable now contains a list of your API's
        # authorized clients.
      })
    });

### Raw usage

As the Gauges API is always evolving, it is important to provide raw API access
to developers. The internal mechanism that is used to create API requests is
exposed by GaugesJS for this reason. When Gauges gives you an API URL, you can
make use of this method to make the request.

As one example, you might want to see which locations are being tracked by a
gauge. Here's an example:

    var gaugesjs = require('gaugesjs'),
        client = gaugesjs.client();

    client.init(function get_api(err, api) {
      api.gauges(function get_clients(err, gauges) {
        var get_locations = api.make_request(gauges.gauges[0].urls.locations);

        get_locations(function (err, locations) {
          # The `locations` variable now contains all locations related to
          # your first gauge in the `gauges` variable.
        });
      })
    });

