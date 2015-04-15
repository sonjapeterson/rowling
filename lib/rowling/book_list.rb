module Rowling
  class BookList
    def initialize(response)
      self.books = parse_entries(response["BookListEntries"])
      self.date = parse_date(response["BookListDate"])
      self.name = response["Name"]
      self.book_list_api_url = response["BookListDate"]["BookListAPIUrl"]
    end

    attr_accessor :books, :date, :name, :book_list_api_url

    def parse_date(date_response)
      date_vals = [date_response["Year"], date_response["Month"], date_response["Date"]]
      date_vals = date_vals.compact.map(&:to_i)
      Date.new(*date_vals)
    end

    def parse_entries(entries_response)
      books = entries_response.map.with_index do |entry, i|
        [i, book = Rowling::Book.new(entry)]
      end
      books.to_h
    end
  end
end
