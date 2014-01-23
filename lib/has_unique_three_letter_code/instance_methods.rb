module HasUniqueThreeLetterCode
  ALPHABET_ARRAY = ('A'..'Z').to_a
  private
    def set_three_letter_column(_)
      return unless self.__send__(_).blank?
      deterministic_three_letter_column(_)
      random_three_letter_column(_) until unique_three_letter_column(_)
    end

    def deterministic_three_letter_column(_)
      value = source_value(_)
      return random_three_letter_column(_) if value.blank?
      acronym = value.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(' ').collect(&:first).join.gsub(/[^A-Za-z]/, '').upcase
      if acronym.size >= 3 then
        acronym.size.times do |i|
          (i+1..acronym.size-1).each do |j|
            (j+1..acronym.size-1).each do |k|
              self.__send__("#{_}=", "#{acronym[i]}#{acronym[j]}#{acronym[k]}")
              return if unique_three_letter_column(_)
            end
          end
          (i+1..acronym.size-1).each do |j|
            ALPHABET_ARRAY.each do |k|
              self.__send__("#{_}=", "#{acronym[i]}#{acronym[j]}#{k}")
              return if unique_three_letter_column(_)
            end
          end
          (i+1..acronym.size-1).each do |j|
            three_letter_column_with_two_fixed_adjacent_letters(_, "#{acronym[i]}#{acronym[j]}")
            return if unique_three_letter_column(_)
          end
          (i+1..acronym.size-1).each do |j|
            three_letter_column_with_two_fixed_split_letters(_, acronym[i], acronym[j])
            return if unique_three_letter_column(_)
          end
          three_letter_column_with_one_fixed_letter(_, acronym[i])
          return if unique_three_letter_column(_)
        end
      elsif 2 == acronym.size
        three_letter_column_with_two_fixed_adjacent_letters(_, acronym)
        return if unique_three_letter_column(_)
        three_letter_column_with_one_fixed_letter(_, acronym[0])
        return if unique_three_letter_column(_)
        three_letter_column_with_one_fixed_letter(_, acronym[1])
      elsif 1 == acronym.size
         three_letter_column_with_one_fixed_letter(_, acronym)
      end
    end

    def random_char
      ALPHABET_ARRAY[Random.rand(0..25)]
    end

    def unique_three_letter_column(_)
      begin
      valid? || self.errors[_].empty?
      rescue => e
        puts e.backtrace.join("\n")
        raise e
      end
    end

    def random_three_letter_column(_)
      self.__send__("#{_}=", "#{random_char}#{random_char}#{random_char}")
    end

    def three_letter_column_with_one_fixed_letter(col, _)
      ALPHABET_ARRAY.each do |i|
        three_letter_column_with_two_fixed_adjacent_letters(col, "#{_}#{i}")
        return if unique_three_letter_column(col)
      end
    end

    def three_letter_column_with_two_fixed_adjacent_letters(col, _)
      ALPHABET_ARRAY.each do |i|
        self.__send__("#{col}=", "#{_}#{i}")
        return if unique_three_letter_column(col)
      end
    end

    def three_letter_column_with_two_fixed_split_letters(col, i, k)
      ALPHABET_ARRAY.each do |j|
        self.__send__("#{col}=", "#{i}#{j}#{k}")
        return if unique_three_letter_column(col)
      end
    end

    def source_value(_)
      __send__(self.class.code_sources[_])
    end
end
