module Rowling
  class Book
    ATTRIBUTES = [:title, :title_api_url, :author, :class, :description, :book_list_appearances, :highest_rank]

    def initialize(response)
      title_data = response["Title"]
      ATTRIBUTES.each do |key|
        send("#{key}=", title_data[key.to_s.camelize])
      end
      self.category_id = title_data["Category"]["CategoryID"]
      self.category_name = title_data["Category"]["CategoryName"]
      self.ranks = title_data["RankHistories"].map do |rank|
        Rowling::Rank.new(rank)
      end
    end

    attr_accessor *ATTRIBUTES, :category_id, :category_name, :ranks
  end
end

