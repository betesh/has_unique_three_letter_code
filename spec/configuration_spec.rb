require_relative 'spec_helper'

describe HasUniqueThreeLetterCode do
  describe "forbidden_codes" do
    def set(_)
      described_class.config.forbidden_codes=_
    end
    it "cannot be nil" do
      expect{set(nil)}.to raise_error(ArgumentError, "config.forbidden_codes must be an array of 3-character strings.  For example: `config.forbidden_codes = ['ABC', 'DEF', 'GHI']`")
    end
    it "cannot have a 4-character string" do
      expect{set(['ABCD'])}.to raise_error(ArgumentError, "config.forbidden_codes contains an element that is the wrong length: ABCD")
    end
    it "cannot have a 2-character string" do
      expect{set(['AB'])}.to raise_error(ArgumentError, "config.forbidden_codes contains an element that is the wrong length: AB")
    end
    it "cannot have 2 elements with the wrong number of characters" do
      expect{set(['ABCD', 'EF'])}.to raise_error(ArgumentError, "config.forbidden_codes contains elements that are the wrong length: ABCD, EF")
    end
    it "cannot have an element with a non-alpha character" do
      expect{set(['AB1'])}.to raise_error(ArgumentError, "config.forbidden_codes contains an element with characters other than capital letters: AB1")
    end
    it "cannot have an element with a non-alpha character" do
      expect{set(['AB1', '2CD'])}.to raise_error(ArgumentError, "config.forbidden_codes contains elements with characters other than capital letters: AB1, 2CD")
    end
    it "can be an empty array" do
      expect{set([])}.to_not raise_error
    end
  end

  after(:all) { described_class.config.reset }
end
