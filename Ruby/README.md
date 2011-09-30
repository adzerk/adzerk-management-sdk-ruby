# Adzerk

Ruby wrapper for the [Adzerk API](http://adzerk.com/).

## Installation

    sudo gem install adzerk
    
## Get your API key

Be sure and get your API key. Log into the management application at [http://manage.adzerk.net/](http://manage.adzerk.net/). Then, click on the settings tab, followed by the API Keys tab.

## Usage

Refer to the [https://github.com/adzerk/adzerk-api/wiki](wiki) of this repository for the properties needed for update and create. 

### Examples

    require 'adzerk'
    require 'adzerk/site'
    adzerk = Adzerk.new('your_api_key')
    adzerk::Site.list()

    require 'adzerk'
    require 'adzerk/advertiser'
    adzerk = Adzerk.new 'your_api_key'
    adzerk::Advertiser.create {
      'Title' => "Example Advertiser",
      'IsActive' => true,
      'IsDeleted' => false
    }

Copyright (c) 2011 Adzerk, Inc.