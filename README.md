# Etsy scraper

Scraper for www.etsy.com

## Description

This script parses profile information and reviews (3 pages by default) and write them into json file.

### Profile information

* Seller name (str)
* Profile description (str)
* Logo URL (str)
* Reported rating (float)
* Reporter number of reviews (int)

### Review information

* Reviewer’s name (if any) (str)
* Review text (if any) (str)
* Date (str) format: yyyy-mm-dd
* Rating (float)
* Profile picture URL (if any) (str)

## Install

### Clone the repository

```shell
git clone git@github.com:blimp666/etsy_scraper.git
cd etsy_scraper
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 3.1.2`

Might work with older ruby versions. If not, install the right ruby version.

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)

```shell
bundle install
```

## Usage

### Scraping a single shop

Run script with -s argument

```shell
ruby scraper.rb -s MasterOak
```

### Scraping shops from file

Run scrit with -f argument (see the file example in the repo)

```shell
ruby scraper.rb -f input_list
```

## Tests

Run rspec with

```shell
rspec spec
```
