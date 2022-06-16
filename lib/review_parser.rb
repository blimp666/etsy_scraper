require 'time'

class ReviewParser
  # CSS selectors inside the review item element
  REVIEW_SELECTORS = {
    reviewer_name: 'p.shop2-review-attribution a',
    reviewer_text: 'p.prose.break-word',
    review_date: 'p.shop2-review-attribution',
    rating: 'input[name="rating"]',
    profile_picture_url: 'div:first-of-type div:first-of-type img'
  }

  def initialize(review_source)
    @review_source = review_source
  end

  def parse
    REVIEW_SELECTORS.map do |attribute, selector|
      [attribute, self.send("get_#{attribute}", selector)]
    end.to_h
  end

  private

  def get_reviewer_name(selector)
    @review_source.at_css(selector)&.text
  end

  def get_reviewer_text(selector)
    @review_source.at_css(selector)&.text
  end

  def get_review_date(selector)
    Date.
      parse(@review_source.at_css(selector).children.last.text).
      strftime('%Y-%m-%d')
  end

  def get_rating(selector)
    @review_source.at_css(selector).attr('value').to_f
  end

  def get_profile_picture_url(selector)
    url = @review_source.at_css(selector).attr('src')
    url unless url.include?('default_avatar')
  end
end
