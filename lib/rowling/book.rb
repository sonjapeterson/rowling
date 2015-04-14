module Rowling
  class Book
    ATTRIBUTES = [:title, :title_api_url, :author, :class, :description, :book_list_appearances, :highest_rank, :rank_last_week, :isbn, :asin]

    def initialize(response)
      ATTRIBUTES.each do |key|
        send("#{key}=", response[key.to_s.camelize]) if response[key.to_s.camelize]
      end
      if descrip = response["BriefDescription"]
        self.description = descrip
      end
      if response["Category"]
        self.category_id = response["Category"]["CategoryID"]
        self.category_name = response["Category"]["CategoryName"]
      end
      if response["RankHistories"]
        self.ranks = response["RankHistories"].map do |rank|
          Rowling::Rank.new(rank)
        end
      end
    end

    attr_accessor *ATTRIBUTES, :category_id, :category_name, :ranks
  end
end

