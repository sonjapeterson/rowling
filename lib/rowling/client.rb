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
      class_response = make_request({segments: "classes", query: args})
      class_response["Classes"]
    end

    def get_categories(args={})
      category_response = make_request({segments: "categories", query: args})
      category_response["Categories"]
    end

    def get_dates(args={})
      date_response = make_request({segments: "dates", query: args})
      date_response["Dates"]
    end

    def search_books(args={}, raw=false)
      segments = "titles"
      book_response = make_request({segments: segments, query: args})
      if raw
        book_response
      else
        if titles = book_response["Titles"]
          titles.map do |title|
            Rowling::Book.new(title)
          end
        else
          []
        end
      end
    end

    def find_book_by_isbn(isbn, raw=false)
      segments = ["titles", isbn]
      if raw
        make_request({ segments: segments }, true)
      else
        begin
          book_response = make_request({ segments: segments })
          Rowling::Book.new(book_response["Title"])
        rescue Rowling::Response503Error => e
          return nil
        end
      end
    end

    def get_detailed_version(book, raw=false)
      if book.title_api_url
        segments = book.title_api_url
        book_response = make_request({ segments: segments })
        if raw
          book_response
        else
          Rowling::Book.new(book_response["Title"])
        end
      else
        raise StandardError "Can't find details for book without title api url set"
      end
    end

    def make_request(args={}, raw=false, tries=0)
      if self.api_key
        query = { "api_key" => self.api_key }
        query.merge!(args[:query]) if args[:query]
        url = base_template.expand({segments: args[:segments], query: query})
        response = HTTParty.get(url)
        if raw
          response
        else
          if tries < 2
            begin
              check_errors(response)
            rescue Rowling::Response403Error
              tries += 1
              sleep(2)
              make_request(args, false, tries)
            end
          else
            check_errors(response)
          end
        end
      else
        raise Rowling::NoAPIKeyError
      end
    end

    def check_errors(response)
      if response.code == 503
        raise Rowling::Response503Error
      elsif response.code == 403
        raise Rowling::Response403Error
      elsif response.code != 200
        raise Rowling::ResponseError, "Request Failed. Code #{response.code}."
      else
        response
      end
    end
  end
end
