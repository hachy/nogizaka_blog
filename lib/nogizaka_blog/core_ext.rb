module NogizakaBlogExtentions
  refine Array do
    def sum
      map(&:to_i).inject(:+)
    end
  end
end
