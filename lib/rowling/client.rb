module Rowling
  class Client
    include HTTParty

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

    def get_book(args={})
      isbn = args.delete(:isbn)
      segments = ["titles"]
      segments << isbn if isbn
      errors = []
      begin
        book_response = make_request({segments: segments, query: args})
      rescue StandardError => e
        if book_response.code == 503 && args[:isbn]
          errors << "Book with ISBN #{args[:isbn]} not found, or you've made too many requests."
        elsif book_response.code != 200 
          errors << e.message
        end
      end
      if errors.empty?
        Rowling::Book.new(book_response)
      else
        puts errors.join("\n")
      end
    end

    def make_request(args={})
      if self.api_key
        query = { api_key: self.api_key }
        query.merge!(args[:options]) if args[:options]
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
