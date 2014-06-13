# Morito

A client to handle robots.txt

## Installation

Add this line to your application's Gemfile:

    gem 'morito'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install morito

## Usage

```ruby
client = Morito::Client.new('some user agent')
client.allowed?('http://example.com/some/path') # => true / false
client.allowed?('http://example.com/some/path', cache: false) # => true / false without cache
```

## Contributing

1. Fork it ( https://github.com/negipo/morito/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
