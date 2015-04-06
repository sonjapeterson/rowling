require 'helper'

describe Rowling::Client do

  before do
    @client = Rowling::Client.new(api_key: ENV["USATODAY_BESTSELLER_KEY"], format: :json)
  end

  it "should configure valid configuration keys" do
    @client.api_key.must_equal ENV["USATODAY_BESTSELLER_KEY"]
    @client.format.must_equal :json
  end

  it "should raise an error if you try to make a request without an API key" do
    @client.api_key = nil
    proc { @client.make_request }.must_raise StandardError
  end

  describe "requests", :vcr do
    it "should get classes" do
      classes = @client.get_classes
      classes.must_equal ["---", "Fiction", "NonFiction"]
    end

    it "should find a book based on a valid ISBN" do
      book = @client.find_book_by_isbn("9780758280428")
      book.must_be_instance_of Rowling::Book
    end

    it "should search for books by title" do
      books = @client.search_books(author: "J.K. Rowling")
      books.first.must_be_instance_of Rowling::Book
    end

    it "should get a detailed version of a book found through search" do
      books = @client.search_books(author: "J.K. Rowling")
      detailed_book = @client.get_detailed_version(books.first)
      detailed_book.must_be_instance_of Rowling::Book
      detailed_book.title.must_equal "Fantastic Beasts & Where to Find Them"
      detailed_book.ranks.count.must_equal 24
      detailed_book.category_id.must_equal 140
      detailed_book.category_name.must_equal "Youth"
    end

    describe "when raw is set to true" do

      it "should return a raw response for book search" do
        response = @client.find_book_by_isbn("9780758280428", true)
        response.must_be_instance_of Hash
      end

      it "should return a raw response for finding a book based on ISBN" do
        response = @client.search_books({author: "J.K. Rowling"}, true)
        response.must_be_instance_of Hash
      end
    end
  end
end
