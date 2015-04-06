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

  end
end
