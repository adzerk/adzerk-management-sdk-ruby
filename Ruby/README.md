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

    Adzerk::Channel.create(json)
    Adzerk::Channel.get(id)
    Adzerk::Channel.list()
    Adzerk::Channel.update(json)
    Adzerk::Channel.delete(id)
    
### Flights

    Adzerk::Flight.create(json)
    Adzerk::Flight.get(id)
    Adzerk::Flight.list()
    Adzerk::Flight.update(json)
    Adzerk::Flight.delete(id)
        
### Publishers

    Adzerk::Publisher.create(json)
    Adzerk::Publisher.get(id)
    Adzerk::Publisher.list()
    Adzerk::Publisher.update(json)
    Adzerk::Publisher.delete(id)
    
### Sites

    Adzerk::Site.create(json)
    Adzerk::Site.get(id)
    Adzerk::Site.list()
    Adzerk::Site.update(json)
    Adzerk::Site.delete(id)
    
### Logins

    Adzerk::Login.create(json)
    Adzerk::Login.get(id)
    Adzerk::Login.list()
    Adzerk::Login.update(json)
        
### Reporting

    Adzerk::Reporting.create_report(json)


Copyright (c) 2011 Adzerk, Inc.