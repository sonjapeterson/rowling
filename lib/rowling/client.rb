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

    def search_books(args={})
      segments = "titles"
      book_response = make_request({segments: segments, query: args})
      if self.raw
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

    def find_book_by_isbn(isbn)
      segments = ["titles", isbn]
      if self.raw
        make_request({ segments: segments })
      else
        begin
          book_response = make_request({ segments: segments })
          Rowling::Book.new(book_response["Title"])
        rescue Rowling::Response503Error, Rowling::Response400Error => e
          return nil
        end
      end
    end

    def get_booklists(args={})
      date_segments = [:year, :month, :day].map do |segment|
        args.delete(segment)
      end
      segments = ["booklists"].concat(date_segments.compact)
      response = make_request({ segments: segments, args: args})
      if self.raw
        response
      elsif lists = response["BookLists"]
        lists.map{ |list| BookList.new(list) }
      else
        {}
      end
    end

    def get_detailed_version(book)
      if book.title_api_url
        segments = book.title_api_url
        book_response = make_request({ segments: segments })
        if self.raw
          book_response
        else
          Rowling::Book.new(book_response["Title"])
        end
      else
        raise Rowling::ResponseError "Can't retrieve details for book without title api url set"
      end
    end

    def make_request(args={}, tries=0)
      if self.api_key
        uri = build_uri(args)
        response = HTTParty.get(uri)
        if self.raw
          response
        else
          if tries < 2
            begin
              check_errors(response)
            rescue Rowling::Response403Error
              tries += 1
              sleep(2)
              make_request(args, tries)
            end
          else
            check_errors(response)
          end
        end
      else
        raise Rowling::NoAPIKeyError
      end
    end

    def build_uri(args)
      query = { "api_key" => self.api_key }
      query.merge!(args[:query]) if args[:query]
      base_template.expand({segments: args[:segments], query: query}).to_s
    end

    def check_errors(response)
      if response.code == 503
        raise Rowling::Response503Error
      elsif response.code == 400
        raise Rowling::Response400Error
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
