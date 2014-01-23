class Client < ActiveRecord::Base
  attr_accessible :tla, :name, :needs_tla, :tla_group
end
