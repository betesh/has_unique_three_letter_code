require "active_record/validations"

module HasUniqueThreeLetterCode
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :code_sources
    def has_unique_three_letter_code(*columns)
      options = columns.last.is_a?(Hash) ? columns.pop : {}
      columns.each do |column|
        validates column,
            :uniqueness => (options[:uniqueness] || true),
            :length => {:is => 3, :allow_nil => true}.merge(options[:length] || {}),
            :exclusion => { :in => Proc.new { HasUniqueThreeLetterCode.config.forbidden_codes }, :message => "'%{value}' is not an appropriate word" }
        (@code_sources ||= {})[column] = options[:source] || :name
        before_validation do
          if options[:leave_blank]
            leave_blank = options[:leave_blank][:if]
            if (leave_blank.blank? || (leave_blank.is_a?(Proc) && !leave_blank.call(self)) || (leave_blank.is_a?(Symbol) && !self.__send__(leave_blank)))
              dont_leave_blank = options[:leave_blank][:unless]
              if (dont_leave_blank.blank? || (dont_leave_blank.is_a?(Proc) && dont_leave_blank.call(self)) || (dont_leave_blank.is_a?(Symbol) && self.__send__(dont_leave_blank)))
                set_three_letter_column column if self.__send__(column).blank?
              end
            end
          else
            set_three_letter_column column if self.__send__(column).blank?
          end
        end
      end
    end
  end
end
