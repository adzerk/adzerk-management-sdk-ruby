# Adzerk

Ruby wrapper for the [Adzerk API](http://adzerk.com/).

## Installation

    sudo gem install adzerk

## Get your API key

Be sure and get your API key. Log into the management application at [http://manage.adzerk.net/](http://manage.adzerk.net/). Then, click on the settings tab, followed by the API Keys tab.

## Usage

Refer to the [https://github.com/adzerk/adzerk-api/wiki](https://github.com/adzerk/adzerk-api/wiki) of this repository for the properties needed for update and create.

### Examples

    require 'adzerk'
    client = Adzerk::Client.new('your_api_key')
    client.sites.list

## To run tests as Adzerk developer

    bundle install
    export ADZERK_API_KEY=<get-key-from-adzerk>
    rake spec

## License

Copyright © 2011-2017 Adzerk, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  You may obtain a copy of the
License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.
