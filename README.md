# Alerty::Plugin::AmazonSns

Amazon SNS plugin for alerty

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alerty-plugin-amazon_sns'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alerty-plugin-amazon_sns

## Configuration

* **type**: must be `amazon_sns`
* **topc_name**: Amazon SNS topic name
* **subject**: subject of alert. `${command}` is replaced with a given command, `${hostname}` is replaced with the hostname ran a command
* **aws_region**: AWS Region. (default: ENV["AWS_REGION'])
* **aws_access_key_id**: Credential key id (default: ENV['AWS_SECRET_KEY_id'] or ~/.aws/credentials or instance profile on EC2)
* **aws_secret_access_key**: Credential secret access_key (default: ENV['AWS_SECRET_ACCESS_KEY'] or ~/.aws/credentials or instance profile on EC2)

See [example.yml](./example.yml)

## ChangeLog

See [CHANGELOG.md](./CHANGELOG.md)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sonots/alerty-plugin-amazon_sns. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

