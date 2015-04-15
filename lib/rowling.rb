require "httparty"
require "addressable/uri"
require "addressable/template"
require "date"
require "ext/string.rb"
require "rowling/version.rb"
require "rowling/configuration.rb"
require "rowling/book.rb"
require "rowling/rank.rb"
require "rowling/exceptions.rb"
require "rowling/book_list.rb"
require "rowling/client.rb"

module Rowling
  extend Configuration
end
