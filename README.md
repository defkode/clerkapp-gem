# Clerkapp

Provides a simple ruby wrapper around the Clerkapp API

## Installation

Add this line to your application's Gemfile:

    gem 'clerkapp', require: 'clerk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clerkapp

## Usage

Lets make few assumptions:

- you have clerkapp addon added to your application
```term
$ heroku addons:add clerk
```
- you have form uploaded with identifier `your-awesome-form` ([how to upload a pdf form](#uploading-pdf-forms)).
- your form has fields named `name`, `gender`, `newsletter`.

We can print our first form with few lines of code:
```ruby
File.open("test_printout.pdf", "wb") do |f|
  pdf_content = Clerkapp.print("your-awesome-form", {
    "name"       => "Johm Mayer",
    "gender"     => "0",
    "newsletter" => "Y"
  })
  f.write pdf_content.read
end
```

#### Other usage example

```ruby
# without options
Clerk::Form.print(form_identifier, fields) do |file_url, error|
  if error
    handle_failure(error)
  else
    handle_success(file_url)
  end
end
```

```ruby
# with options
Clerk::Form.print(form_identifier, fields, {test: true}) do |file_url, error|
  if error
    handle_failure(error)
  else
    handle_success(file_url)
  end
end
```

```ruby
# with file rather than file_url
Clerk::Form.print(form_identifier, fields, {file: true}) do |file, error|
  if error
    handle_failure(error)
  else
    handle_success(file)
  end
end
```

```ruby
# without block (raises on error)
begin
  file_url = Clerk::Form.print(form_identifier, fields, {test: true})
rescue => exeption
  # handle exception based on exception types
end
```

### Uploading pdf forms

To upload pdf form open dashboard

```term
$ heroku addons:open clerk
```

Select file from hard drive or paste url and click `Upload`. In no time your first form is uploaded with identifier set to a filename. That's all, you can now print your first document.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/clerkapp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
