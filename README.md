# Adzerk

Ruby wrapper for the [Adzerk](https://adzerk.com) API.

## Installation

```bash
sudo gem install adzerk
```

## Get your API key

To obtain your Adzerk API key:

- Log into the management application at http://_yournetwork_.adzerk.com.
- Click on the Settings tab.
- Click on the API Keys tab.
- Check to make sure that the API key you are using is enabled.

## Usage

Refer to the [Adzerk Knowledge Base](http://dev.adzerk.com) for information about the properties needed to create and update ads, flights, etc.

### Examples

```ruby
require 'adzerk'
client = Adzerk::Client.new(ENV["ADZERK_API_KEY"])
pp client.sites.list
```

## To run tests as Adzerk developer

    bundle install
    run `sql-env` to set environment vars
    export ADZERK_API_KEY=$(api-key 12345)
    bundle exec rspec test_name.rb

## License

Copyright © 2011-2020 Adzerk, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  You may obtain a copy of the
License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.
