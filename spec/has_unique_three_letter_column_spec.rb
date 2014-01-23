require_relative 'spec_helper'

def tla_of(_)
  _.tap(&:valid?).tla
end

RSpec::Matchers.define :be_assigned_tla do |expected|
  match do |actual|
    tla_of(actual) == expected
  end
end

RSpec::Matchers.define :be_assigned_any_3_letter_tla do
  match do |actual|
    /\A[A-Z]{3}\z/.match(tla_of(actual))
  end
end

RSpec::Matchers.define :be_3_letters_beginning_with do |expected|
  match do |actual|
    /\A#{expected}[A-Z]{#{3 - expected.size}}\z/.match(tla_of(actual))
  end
end


describe Client do
  describe "tla" do
    def given_tla_is_unavailable(_)
      Client.create!(:tla => _) unless HasUniqueThreeLetterCode.config.forbidden_codes.include?(_)
    end

    def given_all_codes_are_taken_that_begin_with(_)
      if 1 == _.size
        Client::ALPHABET_ARRAY.each do |a|
          Client::ALPHABET_ARRAY.each do |b|
            given_tla_is_unavailable("#{_}#{a}#{b}")
          end
        end
      elsif 2 == _.size
        Client::ALPHABET_ARRAY.each do |a|
          given_tla_is_unavailable("#{_}#{a}")
        end
      end
    end

    describe '> 3 letters in initials' do
      let(:target) { Client.new(:name => "John Deere Tractors & Farm Equipment, Ltd.") }

      it "should be all caps" do
        Client.new(:name => 'lower case letters').should be_assigned_tla('LCL')
      end

      it "should be the 1st 3 initials of business name" do
        target.should be_assigned_tla('JDT')
      end

      it "should be the 1st, 2nd and 4th initials in business name when 1st 3 are non-unique" do
        given_tla_is_unavailable('JDT')
        target.should be_assigned_tla('JDF')
      end

      it "should be the 1st, 3rd and 4th initials in business name when 1st 2 and any later ones are non-unique" do
        ['JDT', 'JDF', 'JDE', 'JDL'].each do |_|
          given_tla_is_unavailable(_)
        end
        target.should be_assigned_tla('JTF')
      end

      it "should be the 1st, 3rd and 5th initials in business name when 1st 2 and any later ones are non-unique and 1st, 3rd and 4th are non-unique" do
        ['JDT', 'JDF', 'JDE', 'JDL', 'JTF'].each do |_|
          given_tla_is_unavailable(_)
        end
        target.should be_assigned_tla('JTE')
      end

      it "should begin with the 1st 2 initials in business name when 1st 2 with any later one is non-unique" do
        ['JDT', 'JDF', 'JDE', 'JDL', 'JTF', 'JTE', 'JTL', 'JFE', 'JFL', 'JEL'].each do |_|
          given_tla_is_unavailable(_)
        end
        target.should be_assigned_tla('JDA')
      end

      it "should begin with the 1st and 3rd initial in business name when 1st 2 with any letter and 1st and 3rd with any later initial is non-unique" do
        Client::ALPHABET_ARRAY.each do |_|
          given_tla_is_unavailable("JD#{_}")
        end
        ['JTF', 'JTE', 'JTL', 'JFE', 'JFL', 'JEL'].each do |_|
          given_tla_is_unavailable(_)
        end
        target.should be_assigned_tla('JTA')
      end

      it "should be the 1st and last initial in business name with another letter after them when no other ordered combination of 2 initials from the business_name is unique with any 3rd letter" do
        Client::ALPHABET_ARRAY.each do |_|
          given_tla_is_unavailable("JD#{_}")
          given_tla_is_unavailable("JT#{_}")
          given_tla_is_unavailable("JF#{_}")
          given_tla_is_unavailable("JE#{_}")
        end
        target.should be_assigned_tla('JLA')
      end

      it "should be the 1st and 2nd initial in business name with another letter between them when no ordered combination of 2 initials from the business_name is unique with any 3rd letter" do
        Client::ALPHABET_ARRAY.each do |_|
          given_tla_is_unavailable("JD#{_}")
          given_tla_is_unavailable("JT#{_}")
          given_tla_is_unavailable("JF#{_}")
          given_tla_is_unavailable("JE#{_}")
          given_tla_is_unavailable("JL#{_}")
        end
        target.should be_assigned_tla('JAD')
      end

      it "should begin with the 1st initial in business name when any ordered combination of initials is non-unique" do
        given_all_codes_are_taken_that_begin_with('JD')
        ['JTF', 'JTE', 'JTL', 'JFE', 'JFL', 'JEL'].each do |_|
          given_tla_is_unavailable(_)
        end
        target.should be_assigned_tla('JTA')
      end

      it "should be the 2nd, 3rd and 4th initial in business name when any 3-letter combination beginning with the first letter is non-unique" do
        given_all_codes_are_taken_that_begin_with('J')
        target.should be_assigned_tla('DTF')
      end

      it "should be the 2nd, 3rd and 5th initial in business name when any 3-letter combination beginning with the first letter, and the 2nd, 3rd and 4th, are non-unique" do
        given_all_codes_are_taken_that_begin_with('J')
        given_tla_is_unavailable('DTF')
        target.should be_assigned_tla('DTE')
      end

      it "should begin with the last initial when all codes beginning with any other initials in business name are taken" do
        'JDTFE'.each_char do |_|
          given_all_codes_are_taken_that_begin_with(_)
        end
        target.should be_assigned_tla('LAA')
      end

      it "should be random when all codes beginning with any initials in business name are taken" do
        'JDTFEL'.each_char do |_|
          given_all_codes_are_taken_that_begin_with(_)
        end
        target.should be_assigned_any_3_letter_tla
      end
    end

    describe '2 letters in initials' do
      let(:target) { Client.new(:name => 'Teddy Bears') }

      it "should be the 1st 2 initials of business name plus a random letter" do
        target.should be_3_letters_beginning_with('TB')
      end

      it "should be the 1st initial of business name plus two random letters if all ordered combinations of the 1st 2 initials plus a 3rd letter are taken" do
        given_all_codes_are_taken_that_begin_with('TB')
        target.should be_3_letters_beginning_with('T')
      end

      it "should be random if all ordered combinations beginning with the first letter are taken" do
        given_all_codes_are_taken_that_begin_with('T')
        target.should be_assigned_any_3_letter_tla
      end
    end


    describe '1 letter initials' do
      let (:target) { Client.new(:name => 'Switzerland') }

      it "should be the initial of business name plus 2 random letters" do
        target.should be_3_letters_beginning_with('S')
      end

      it "should be random if all ordered combinations beginning with the first letter are taken" do
        given_all_codes_are_taken_that_begin_with('S')
        target.should be_assigned_any_3_letter_tla
      end
    end

    it "should be random if business_name is blank" do
      Client.new.should be_assigned_any_3_letter_tla
    end
  end

  describe "scoping uniqueness" do
    it "should not allow two clients in the same tla_group to share a TLA" do
      Client.create!(:name => 'A B C D', :tla_group => 1).should be_assigned_tla('ABC')
      Client.create!(:name => 'A B C D', :tla_group => 1).should be_assigned_tla('ABD')
    end

    it "should allow two clients in different tla_groups to share a TLA" do
      Client.create!(:name => 'A B C D', :tla_group => 1).should be_assigned_tla('ABC')
      Client.create!(:name => 'A B C D', :tla_group => 2).should be_assigned_tla('ABC')
    end
  end

  describe "leaving blank" do
    it "should leave the TLA blank if configured with leave_blank" do
      Client.create!(:name => 'A B C D', :needs_tla => false).should be_assigned_tla(nil)
    end
  end

  describe "forbidden_codes" do
    it "should not allow a TLA that is a forbidden code" do
      Client.new(:name => 'A B C D').should be_assigned_tla('ABC')
      HasUniqueThreeLetterCode.config.forbidden_codes = ['ABC']
      Client.new(:name => 'A B C D').should be_assigned_tla('ABD')
    end

    after(:each) { HasUniqueThreeLetterCode.config.reset }
  end
end
