module Rowling
  class Client

    attr_accessor *Configuration::CONFIGURATION_KEYS

    def initialize(args={})
      Configuration::CONFIGURATION_KEYS.each do |key|
        send("#{key}=", args[key])
      end
    end

    def base_template
      template = Addressable::Template.new("http://api.usatoday.com/open/bestsellers/books{/segments*}{?query*}")
    end

    def get_classes(args={})
      class_response = make_request({segments: "classes"})
      class_response["Classes"]
    end

    def search_books(args={})
      segments = ["titles"]
      book_response = make_request({segments: segments, query: args})
      if titles = book_response["Titles"]
        titles.map do |title|
          Rowling::Book.new(title)
        end
      else
        []
      end
    end

    def find_book_by_isbn(isbn)
      segments = ["titles", isbn]
      book_response = make_request({ segments: segments })
      Rowling::Book.new(book_response["Title"])
    end


    def make_request(args={})
      if self.api_key
        query = { api_key: self.api_key }
        query.merge!(args[:query]) if args[:query]
        url = base_template.expand({
          segments: args[:segments],
          query: query}) 
        response = HTTParty.get(url)
        if response.code != 200
          raise StandardError, "Request Failed. Code #{response.code}."
          response
        else
          response
        end
      else
        raise StandardError, "You must set an API key before making a request."
      end
    end
  end
end
