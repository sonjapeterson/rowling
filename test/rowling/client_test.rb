require 'helper'

describe Rowling::Client do

  before do
    @client = Rowling::Client.new(api_key: ENV["USATODAY_BESTSELLER_KEY"], format: :json)
  end

  it "should configure valid configuration keys" do
    @client.api_key.must_equal ENV["USATODAY_BESTSELLER_KEY"]
    @client.format.must_equal :json
  end

  describe "requests", :vcr do
    it "should get classes" do
      classes = @client.get_classes
      classes.must_equal ["---", "Fiction", "NonFiction"]
    end

    it "should find a book" do
      book = @client.get_book(isbn: "9780758280428")
      book.must_be_instance_of Rowling::Book
    end
  end
end
