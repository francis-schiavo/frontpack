# Frontpack

This project aims to provide a standard front-end development environment for Ruby on Rails applications.

Key features:
* New form builder with options for enum fields, toggle fields, and autocomplete fields.
* New methods for ActiveRecord models to easily translate enum field names and values.
* New methods for ActiveRecord models to easily expose autocomplete endpoints.
* Integrated sass files for customizing the front end (kinda of a mix including some boostrap and tailwind features).
* Integrated javascript files and web components for customizing the front end and form builder.

## Goals

Allow even faster development of Rails applications by adding more features for front-end.
Some of the features will be simple extensions for Rails form builders.

Other features will be more complex, like having a standard CSS lib and web components. The idea is to provide a high degree
of customization for the front-end, while keeping a standard development process.

Realistically this project will not replace the need for a project specific front-end for larger projects, but it can
be a good alternative for internal use applications where faster development time matters more than a creative and unique UI.

Also, this project will likely be a lot more open to contributions since the idea is to provide a wide range of options
out of the box. As long as a feature is not too specific it will be welcome here.

Keep in mind this project will favor faster development over a faster runtime. That means we won't bother losing a few
milliseconds of page load time if that means we can save a few hours of development time.

## Setup

Run `bundle add frontpack`

Or manually add this line to your application's Gemfile:

```ruby
gem 'frontpack'
```

And then execute:
```bash
$ bundle
```

## TODO
Possibly remove the embedded css files and make it a plugin for this gem. It already works fine with Bootstrap.

## Contributing
WIP

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
