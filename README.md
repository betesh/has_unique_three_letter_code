# HasUniqueThreeLetterCode

User requirements: Assign a case-insensitive unique three-letter code to each record in a scope, based loosely on some other attribute of the record.

Example: Within the office, we refer to each client by a TLA (three-letter acronym).  We want to store the TLA's in our database automatically when we create a client, and we want the TLA to be loosely based on the client's name.  The National Rifle Association is the NRA.  The Office of Management and Budget is the OMB.  The National Restaurant Association--well, NRA is already taken, so how about NRX?

Solution: HasUniqueThreeLetterCode

## Installation

Add this line to your application's Gemfile:

    gem 'has_unique_three_letter_code'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_unique_three_letter_code

## Usage

    class Client < ActiveRecord::Base
      attr_accessible :tla, :name, :tla_group

      include HasUniqueThreeLetterCode
      def needs_tla?
        # Maybe clients that went out of business can have their TLA retired.
        # Or maybe you don't need a TLA for a client with a monosyllabic name
      end
      has_unique_three_letter_code :tla,
        :source => :name, # The field we use to generate the TLA.  This can be another column in this table, or any other method an instance of the class responds_to?, so if it's in another table, just `delegate :name, :to => :the_associated_record`
        :uniqueness => { :scope => :tla_group }, # uniqueness constraints are passed directly to validates_uniqueness_of
        :leave_blank => { :unless => :needs_tla? } # :leave_blank supports keys :if and :unless.  Values can be Procs or symbolized instance method names.
    end

## Future development possibilities

1. Support options for lowercase and case-sensitive.
2. Support N-letter codes.
3. Before resorting to a random letter, search for an available combination using the first two letters of a word.
4. When choosing a random letter, run through them randomly without repetition, instead of alphabetically.
5. Add support for Rails 4

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
