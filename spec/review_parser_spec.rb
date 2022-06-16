require 'nokogiri'
require 'rspec/its'
require_relative '../lib/review_parser'

describe ReviewParser do
  context 'When parsing a single review' do
    before do
      # Very first review in this file has full data.
      # The second one has no avatar (just default).
      # The third one has no text.
      test_file = File.expand_path('reviews.html', __dir__)

      @reviews = Nokogiri::HTML(File.open(test_file)).css('div.review-item')
    end

    describe 'full review' do
      subject { ReviewParser.new(@reviews.first).parse }
       let(:picture_url) { 'https://example.com/path/img_5x5.jpg?v=0' }

       its([:profile_picture_url]) { is_expected.to eq(picture_url) }
       its([:reviewer_name]) { is_expected.to eq('Carrie') }
       its([:reviewer_text]) { is_expected.to eq('It is beautiful!') }
       its([:review_date]) { is_expected.to eq('2022-06-12') }
       its([:rating]) { is_expected.to eq(5.0) }
    end

    describe 'review with a default avatar' do
      subject { ReviewParser.new(@reviews[1]).parse }

      its([:profile_picture_url]) { is_expected.to be_nil }
    end

    describe 'rewiew with an empty text' do
      subject { ReviewParser.new(@reviews[2]).parse }

      its([:reviewer_text]) { is_expected.to be_nil }
    end
  end
end
