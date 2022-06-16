class SellerParser
  SELLER_SELECTORS = {
    seller_name: 'div.shop-name-and-title-container h1',
    description: 'div.shop-name-and-title-container p',
    logo_url: 'img.shop-icon-external',
    reported_rating: 'div.reviews-total span.stars-svg input[name="rating"]',
    reviews_count: 'div.reviews-total div div:last-of-type'
  }

  def initialize(page)
    @page = page
  end

  def parse
    SELLER_SELECTORS.map do |attribute, selector|
      [attribute, self.send("get_#{attribute}", selector)]
    end.to_h
  end

  private

  def get_logo_url(selector)
    @page.at_css(selector).attr('src')
  end

  def get_seller_name(selector)
    @page.at_css(selector).text
  end

  def get_description(selector)
    @page.at_css(selector).text.strip
  end

  def get_reported_rating(selector)
    @page.at_css(selector).attr('value').to_f
  end

  def get_reviews_count(selector)
    @page.at_css(selector).text.delete('()').to_i
  end
end
