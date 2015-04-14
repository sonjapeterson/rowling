# Rowling

A Ruby wrapper for the USA Today Bestsellers API (work in progress!)

# Usage

Set up a client:

```ruby
client = Rowling::Client.new(api_key: YOUR_KEY)
```

Search for books included in bestseller lists:

```ruby
search_params = { author: "J.K. Rowling",
                  title: "Deathly Hallows"
                }

books = client.search_books(search_params)

```

This returns an array of Book objects:

```ruby
books.first.title = "Harry Potter and the Deathly Hallows"
books.first.author = "J.K. Rowling, art by Mary GrandPre"
books.first.title_api_url = "/Titles/9780545010221"
```

Books from search only have title, author and api url. For more detailed information, you can find books directly by ISBN:

```ruby
book = client.find_book_by_isbn("9780545010221")
```
Attributes will include: 

```ruby
title, title_api_url, author, class, description, book_list_appearances, highest_rank, ranks
```

You can also search for book lists by year, month and date. All parameters are optional and without parameters it will retrive the most recent list.

```ruby
client.get_booklists(year: 2015, month: 2)
```
