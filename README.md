BayPhoto [![Build Status][1]](https://travis-ci.org/SnapShotsApp/bay_photo)
========

Integration with BayPhoto's new ordering and pricing API.

API Access
----------

Contact baybizdev@bayphoto.com and they can provide you with an access token for the API.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "bay_photo"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bay_photo

Usage
-----

### Configuration

To use this gem (and the BayPhoto API generally), you must use the access token provided to you by Bay Photo. You
can set this token somewhere like an initializer (if using Rails) or anywhere before you call the API methods
in the gem.

```ruby
require "bay_photo"

BayPhoto.configure do |config|
  config.access_token = "xxx"
end
```

### Example

You can then start using the classes provided in the gem for API interaction. The classes are named after the
resources from the API documentation you should have access to via your BayPhoto account.

For example, to get the list of Products available to your account, simply run:

```ruby
BayPhoto::Product.all
```

To create a new order, run something like:

```ruby
BayPhoto::Order.create({
  order_name: "your order name",
  order_date: "2015-03-10 03:03:46 UTC",
  shipping_billing_code: "FEDEX2",
  customer: {
    name: "John Doe",
    email: "john_doe@gmail.com",
    phone: "123.123.1234",
    address1: "123 first street",
    address2: "apt 0",
    city: "Santa Cruz",
    state: "CA",
    country: "USA",
    zip: "95426"
  },
  products: [{
      product_id: 686,
      qty: 2,
      image_file_name: "original_filename.jpg",
      image_source_path: "https://www.host.com/1WaPD3YHTwaLJ3y1RhZC",
      crop_height: "100.0",
      crop_width: "100.0",
      crop_x: "100.0",
      crop_y: "100.0",
      degrees_rotated: 0,
      print_services: [
        {
          service_id: 3010
        },
        {
          service_id: 4616
        }
      ]
  }]
})
```

Development
-----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update
the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the
version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
------------

1. Fork it ( https://github.com/SnapShotsApp/bay_photo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[1]: https://travis-ci.org/SnapShotsApp/bay_photo.svg?branch=master
