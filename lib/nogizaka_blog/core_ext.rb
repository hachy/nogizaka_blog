module NogizakaBlog
  module Extentions
    refine String do
      def to_kanji
        MEMBER[self]
      end
    end

    refine Array do
      def sum
        map(&:to_i).inject(:+)
      end
    end
  end
end
