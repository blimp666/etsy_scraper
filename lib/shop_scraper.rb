require 'open-uri'
require 'nokogiri'
require 'json'
require_relative './seller_parser'
require_relative './review_parser'

class ShopScraper
  BASE_URL = 'https://www.etsy.com/shop/'
  REVIEWS_ORDER = 'Recency' # 'Relevancy' or 'Recency'

  def initialize(shop_name)
    @shop_name = shop_name
    @response = Nokogiri::HTML(URI.open("#{BASE_URL}#{shop_name}"))
  end

  def scrape(review_pages_number_to_scrape = 3)
    {
      profile_data: parse_seller_data,
      reviews: scrape_reviews(pages_number = 3)
    }
    #page.search('script[type="application/ld+json"]')
  end

  #  private

  def scrape_reviews(pages_number)
    1.upto(pages_number).map { |i| scrape_reviews_page(i) }.flatten
  end

  def scrape_reviews_page(page_number)
    page_data = request_reviews_page(page_number)
    process_reviews_page(page_data)
  end

  def request_reviews_page(page_number)
    url = "https://www.etsy.com/api/v3/ajax/bespoke/public/neu/specs/shop-reviews?log_performance_metrics=false&specs%5Bshop-reviews%5D%5B%5D=Shop2_ApiSpecs_Reviews&specs%5Bshop-reviews%5D%5B1%5D%5Breviews_per_page%5D=10&specs%5Bshop-reviews%5D%5B1%5D%5Bshould_hide_reviews%5D=true&specs%5Bshop-reviews%5D%5B1%5D%5Bis_in_shop_home%5D=true&specs%5Bshop-reviews%5D%5B1%5D%5Bsort_option%5D=#{REVIEWS_ORDER}&specs%5Bshop-reviews%5D%5B1%5D%5Bshopname%5D=#{@shop_name}&specs%5Bshop-reviews%5D%5B1%5D%5Bpage%5D=#{page_number}"

    html = JSON.parse(URI.open(url).read)['output']['shop-reviews']
    Nokogiri::HTML(html)
  end

  def process_reviews_page(page_data)
    page_data.css('div.review-item').map do |review_data|
      parse_review(review_data)
    end
  end

  def parse_review(review_data)
    ReviewParser.new(review_data).parse
  end

  def parse_seller_data
    SellerParser.new(@response).parse
  end
end
