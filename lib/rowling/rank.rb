module Rowling
  class Rank

    def initialize(response)
      self.date = Rowling::Rank.parse_rank_date(response["BookListDate"])
      self.rank = response["Rank"]
      self.book_list_api_url = response["BookListDate"]["BookListAPIUrl"]
    end

    attr_accessor :date, :rank, :book_list_api_url

    def self.parse_rank_date(date_response)
      Date.new(date_response["Year"].to_i, date_response["Month"].to_i, date_response["Date"].to_i)
    end
  end
end
