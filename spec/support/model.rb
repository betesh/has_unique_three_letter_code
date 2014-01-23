class Client < ActiveRecord::Base
  attr_accessible :tla, :name, :needs_tla, :tla_group

  include HasUniqueThreeLetterCode

  has_unique_three_letter_code :tla, :source => :name,
    :uniqueness => { :scope => :tla_group },
    :leave_blank => { :unless => :needs_tla }
end
