require 'helper'

describe Rowling::Rank do
  it "should convert rank history data to ranks" do
    rank_history = [
      {"BookListDate"=>{"Year"=>"2015", "Month"=>"3", "Date"=>"5", "BookListAPIUrl"=>"BookLists/2015/3/5"}, "Rank"=>39}
    ]
    ranks = rank_history.map{ |rank| Rowling::Rank.new(rank) }
    ranks.first.date.must_equal Date.new(2015, 3, 5)
    ranks.first.rank.must_equal 39
    ranks.first.book_list_api_url.must_equal "BookLists/2015/3/5"
  end
end
