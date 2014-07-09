# Clerkapp

Provides a simple ruby wrapper around the Clerkapp API

## Installation

Add this line to your application's Gemfile:

    gem 'clerkapp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clerkapp

## Usage

Lets make few assumptions:

- you have clerkapp addon added to your application
- you have form uploaded with identifier `test.pdf` ([how to upload a pdf form](#uploading-pdf-forms)).
- your form has fields named `name`, `gender`, `newsletter`.

We can print our first form with few lines of code:
```ruby
File.open("test_printout.pdf", "wb") do |f|
  pdf_content = Clerkapp.print(
    name: "test.pdf",
    fields: {
      name: "Johm Mayer",
      gender: "0",
      newsletter: "Y"
    }
  )
  f.write pdf_content.read
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/clerkapp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
