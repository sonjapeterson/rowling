require 'helper'

describe Rowling::Book do
  before do
    @client = Rowling::Client.new(api_key: ENV["USATODAY_BESTSELLER_KEY"], format: :json)
  end

  it "should parse the attributes of a book from a request when initializing", :vcr do
    book = @client.find_book_by_isbn("9780758280428")
    book.title.must_equal " Double Fudge Brownie Murder"
    book.author.must_equal "Joanne Fluke"
    book.category_id.must_equal 0
    book.category_name.must_equal "----"
    book.book_list_appearances.must_equal 1 
    book.highest_rank.must_equal 39
  end

  it "should parse rank histories as instances of Rowling::Rank", :vcr do
    book = @client.find_book_by_isbn("9780758280428")
    book.ranks.first.must_be_instance_of Rowling::Rank
  end

  it "should create a book when only given partial data" do
    response = {
                "Title" => "Embassytown",
                "Author" => "China Mieville",
                "TitleAPIUrl"=> "/Titles/9781451648539"
    }
    book = Rowling::Book.new(response)
    book.title.must_equal "Embassytown"
    book.author.must_equal "China Mieville"
    book.title_api_url.must_equal "/Titles/9781451648539"
    book.category_id.must_equal nil
  end

end

