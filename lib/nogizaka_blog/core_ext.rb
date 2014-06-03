class String
  def to_kanji
    NogizakaBlog::MEMBER[self]
  end
end

module NogizakaBlog
  module Extentions
    refine Array do
      def sum
        map(&:to_i).inject(:+)
      end
    end
  end
end
