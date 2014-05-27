class Client < ActiveRecord::Base
  include HasUniqueThreeLetterCode

  has_unique_three_letter_code :tla, :source => :name,
    :uniqueness => { :scope => :tla_group },
    :leave_blank => { :unless => :needs_tla }
end
