# Adzerk

Ruby wrapper for the [Adzerk API](http://adzerk.com/).

## Installation

    sudo gem install adzerk
    
## Get your API key

Be sure and get your API key. Log into the management application at [http://manage.adzerk.net/](http://manage.adzerk.net/). Then, click on the settings tab, followed by the API Keys tab.

## Usage

Refer to the [https://github.com/adzerk/adzerk-api/wiki](wiki) of this repository for the properties needed for update and create. 

### Examples

    adzerk = Adzerk.new('your_api_key')
    adzerk::Site.list()

### Campaigns

    Adzerk::Campaign.create(json)
    Adzerk::Campaign.get(id)
    Adzerk::Campaign.list()
    Adzerk::Campaign.update(json)
    Adzerk::Campaign.delete(id)
    
### Channels

    Adzerk::Campaign.create(json)
    Adzerk::Campaign.get(id)
    Adzerk::Campaign.list()
    Adzerk::Campaign.update(json)
    Adzerk::Campaign.delete(id)
    
### Flights

    Adzerk::Campaign.create(json)
    Adzerk::Campaign.get(id)
    Adzerk::Campaign.list()
    Adzerk::Campaign.update(json)
    Adzerk::Campaign.delete(id)
        
### Publishers

    Adzerk::Campaign.create(json)
    Adzerk::Campaign.get(id)
    Adzerk::Campaign.list()
    Adzerk::Campaign.update(json)
    Adzerk::Campaign.delete(id)
    
### Sites

    Adzerk::Campaign.create(json)
    Adzerk::Campaign.get(id)
    Adzerk::Campaign.list()
    Adzerk::Campaign.update(json)
    Adzerk::Campaign.delete(id)


Copyright (c) 2011 Adzerk, Inc.