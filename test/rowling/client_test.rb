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
    proc { @client.make_request }.must_raise Rowling::NoAPIKeyError 
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

    it "should return nil if no book is found by ISBN search" do
      book = @client.find_book_by_isbn("9781555976859")
      book.must_be_nil
    end

    it "should search for books by title" do
      books = @client.search_books(title: "Gone Girl")
      books.first.must_be_instance_of Rowling::Book
    end

    it "should return an empty array if there are no results for a book" do
      books = @client.search_books(author: "Geoffrey Chaucer")
      books.must_equal []
    end

    it "should search for books by multiple parameters" do
      books = @client.search_books(author: "Diana Gabaldon", book: "A Leaf on the Wind of All Hallows")
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

    it "should get a booklist" do
      booklists = @client.get_booklists(year: 2015, month: 2)
      booklists.must_be_instance_of Array
      booklists[0][:date].must_equal Date.new(2015, 2, 26)
      booklists[0][:name].must_equal "Top 150"
      booklists[0][:book_list_api_url].must_equal "BookLists/2015/2/26"
      booklists[0][:books][0].title.must_equal "The Girl on the Train"
    end

    describe "when raw is set to true" do

      describe "when searching by ISBN" do

        it "should return a raw response" do
          response = @client.find_book_by_isbn("9780758280428", true)
          response.must_be_instance_of Hash
        end

        it "should not raise an error when a book is not found" do
          response = @client.find_book_by_isbn("9781555976859", true)
          response.must_be_instance_of String
        end
      end

      it "should return a raw response when searching for a book by parameters" do
        response = @client.search_books({author: "J.K. Rowling"}, true)
        response.must_be_instance_of Hash
      end

    end
  end
end
