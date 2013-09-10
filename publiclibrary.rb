#!/usr/bin/env ruby
### publiclibrary.rb
BOOKS_PER_SHELF_LIMIT = 3

class Library
	attr_reader :shelf_count
	attr_accessor :shelves
	def initialize(shelf_count=0, shelves=[])
		@shelf_count = shelf_count
		@@shelves = shelves

		newShelf = Shelf.new
		newShelf.shelf_number = @@shelves.count + 1   #should be one
		@@shelves.push newShelf
		@shelf_count = @@shelves.count
	end

	def listAllBooks
		@@shelves.each do |s|
			s.listBooksOnShelf
		end
	end

	def self.addShelf
		newShelf = Shelf.new
		newShelf.shelf_number = @@shelves.count + 1
		@@shelves.push newShelf
		@shelf_count = @@shelves.count
		return newShelf
	end

	def self.availableShelf
		if @shelf_count == 0   #If there is no shelf yet, create one.
			return Library.addShelf
		else                   #Ok, there are shelves, now check if any are available.
			@@shelves.each do |s|
				if s.book_count < BOOKS_PER_SHELF_LIMIT
					return s
				end
			end
		end
		return Library.addShelf       #There are no available shelves, need to create another.
	end

# iterate through shelves, and return the shelf that contains the given book.  	
	def self.whichShelf(book)
		@@shelves.each do |s|
			s.book_list.each do |b|
				if book = b
					return s
				end
			end
		end
	end
end


class Shelf
	attr_accessor :shelf_number
	attr_reader :book_count, :book_list
	def initialize(book_count=0, book_list=[], shelf_number=0)
		@book_count = book_count
		@book_list = book_list
		@shelf_number = shelf_number
	end

	def listBooksOnShelf
		@book_list.each do |b|
			puts "#{b.title}, by #{b.author}, on shelf ##{b.bookshelf_number}"
		end
	end

	def isShelfFull
		if @book_count >= BOOKS_PER_SHELF_LIMIT
			return TRUE
		end
	end

	def addBookToShelf(book)
		@book_list.push book
		@book_count = @book_list.count
	end

	def removeBookFromShelf(book)
		new_book_list = []
		@book_list.each do |b|
			if b != book
				new_book_list.push b
			end
		end
		@book_list = new_book_list
		@book_count = @book_list.count
	end
end


class Book
	attr_reader :title, :author
	attr_accessor :bookshelf_number
	def initialize(title="", author="", bookshelf_number=0)
		@title = title
		@author = author
		@bookshelf_number = bookshelf_number
	end

	def self.enshelf newBook
		if newBook.bookshelf_number == 0  #This indicates the book is not yet shelved.
			available_shelf = Library.availableShelf
			newBook.bookshelf_number = available_shelf.shelf_number
			available_shelf.addBookToShelf(newBook)
		else
			puts "This book is currently on shelf #{newbook.bookshelf_number}.  Please unshelf"
			puts " book from that shelf before trying to enshelf."
		end
	end

	def self.unshelf oldBook
		if @bookshelf_number == 0
			puts "This book has already been unshelved.  No change made."
		else
			shelf_with_book = Library.whichShelf(oldBook)
			shelf_with_book.removeBookFromShelf(oldBook)
			@bookshelf_number = 0
		end
	end
end

#create library; this should create the first shelf?
puts "**************"
puts "CREATE LIBRARY"
localLibrary = Library.new

puts "CREATE aBook"
aBook = Book.new("Lord of the Rings", "J.R.R. Tolkien")
Book.enshelf(aBook)
localLibrary.listAllBooks   #this should print out ONE book at this point

puts "CREATE 6 more books"
Book.enshelf(Book.new("Book Two", "Author Two"))
Book.enshelf(Book.new("Book Three", "Author Three"))
Book.enshelf(Book.new("Book Four", "Author Four"))
Book.enshelf(Book.new("Book Five", "Author Five"))
Book.enshelf(Book.new("Book Six", "Author Six"))
Book.enshelf(Book.new("Book Seven", "Author Seven"))
localLibrary.listAllBooks   #this should print out ONE book at this point

puts "BEGIN UN-SHELF for aBook"
Book.unshelf(aBook)
localLibrary.listAllBooks   #this should print out ZERO books again at this point

puts "CREATE BOOK 8"
book8 = Book.new("Book Eight", "Author Eight")
puts "BOOK 8 SHELVES ITSELF"
Book.enshelf(book8)
puts "LIBRARY LISTS ALL BOOKS"
localLibrary.listAllBooks   #this should print out ONE book at this point







