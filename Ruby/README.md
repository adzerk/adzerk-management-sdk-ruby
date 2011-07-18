# Adzerk

Ruby wrapper for the [Adzerk API](http://adzerk.com/).

## Installation

    sudo gem install adzerk
    
## Get your API key

Be sure and get your API key. Log into the management application at [http://manage.adzerk.net/](http://manage.adzerk.net/). Then, click on the settings tab, followed by the API Keys tab.

## Usage

### Examples

    adzerk = Adzerk.new('your_api_key')
    adzerk::Site.list()

### Sites

    Adzerk::Site.create(json)
      - Title
      - Url
      
    Adzerk::Site.get(id)
    
    Adzerk::Site.list()
    
    Adzerk::Site.update(json)
      - Id
      - Title
      - Url
      - PublisherAccountId
      
    Adzerk::Site.delete(id)

Copyright (c) 2011 Adzerk, Inc.