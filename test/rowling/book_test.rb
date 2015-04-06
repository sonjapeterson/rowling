require 'helper'

describe Rowling::Book do
  before do
    @client = Rowling::Client.new(api_key: ENV["USATODAY_BESTSELLER_KEY"], format: :json)
  end

  it "should parse the attributes of a book from a request when initializing", :vcr do
    book = @client.get_book(isbn: "9780758280428")
    book.title.must_equal " Double Fudge Brownie Murder"
    book.author.must_equal "Joanne Fluke"
    book.category_id.must_equal 0
    book.category_name.must_equal "----"
    book.book_list_appearances.must_equal 1 
    book.highest_rank.must_equal 39
  end
end

