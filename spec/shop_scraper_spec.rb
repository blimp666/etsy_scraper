require 'rspec/its'
require_relative '../lib/shop_scraper'

describe ShopScraper do

  before(:all) { @scraper = ShopScraper.new('MasterOak') }

  context 'when initialized' do
    it 'has parsed HTML response' do
      expect(@scraper.instance_variable_get('@response')).
        to be_an_instance_of(Nokogiri::HTML4::Document)
    end
  end

  context 'when the shop scraped' do
    before(:all) do
      @reviews_pages_number = 3
      @result = @scraper.scrape(@reviews_pages_number)
    end

    describe 'seller data' do
      subject { @result[:profile_data] }

      its([:seller_name]) { is_expected.to eq('MasterOak') }
      its([:description]) { is_expected.not_to be_empty }
      its([:logo_url]) { is_expected.not_to be_empty }
      its([:reported_rating]) { is_expected.to be_between(1.0, 5.0) }
      its([:reviews_count]) { is_expected.to be > 100 }
    end


    describe 'reviews data' do
      it 'includes correct number of reviews (10 per page)' do
        expect(@result[:reviews].size).to eq(10 * @reviews_pages_number)
      end

      describe 'first review' do
        subject { @result[:reviews].first }

        its([:reviewer_name]) { is_expected.not_to be_empty }
        its([:rating]) { is_expected.to be_between(1.0, 5.0) }

        it 'has review_date not in the future' do
          expect(Date.parse(subject[:review_date])).to be <= Date.today
        end
      end
    end
  end
end
