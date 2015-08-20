class String
  def to_kanji
    NogizakaBlog::MEMBER[self]
  end
end

if RUBY_VERSION >= '2.1.0'
  module NogizakaBlog
    module Extensions
      refine Array do
        def sum
          map(&:to_i).inject(:+)
        end
      end
    end
  end
else
  class Array
    def sum
      map(&:to_i).inject(:+)
    end
  end
end
