module Rowling
  class Book
    ATTRIBUTES = [:title, :title_api_url, :author, :class, :description, :book_list_appearances, :highest_rank]

    def initialize(request)
      title_data = request["Title"]
      ATTRIBUTES.each do |key|
        send("#{key}=", title_data[key.to_s.camelize])
      end
      self.category_id = title_data["Category"]["CategoryID"]
      self.category_name = title_data["Category"]["CategoryName"]
    end

    attr_accessor *ATTRIBUTES, :category_id, :category_name
  end
end

