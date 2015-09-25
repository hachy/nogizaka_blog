require 'thor'

module NogizakaBlog
  Thread.abort_on_exception = true

  class CLI < Thor
    GLYPHS = %w(| / - \\ | / - \\)

    desc 'when YEARMONTH', 'Show the number of comments and articles'
    method_option :sort, aliases: '-s', desc: 'set comment or article'
    def when(yearmonth)
      @nogi = Amazing.new(yearmonth)
      print_header
      spinner
      case options[:sort]
      when 'comment' then sort_by_comment
      when 'article' then sort_by_article
      else normal
      end
    end

    private

    def print_header
      ym = @nogi.yearmonth
      puts "#{ym[0..3]}/#{ym[4..5]}"
      head = display_format('name', 'comment', 'article')
      puts head
      puts '-' * head.size
    end

    def spinner
      Thread.new do
        loop do
          GLYPHS.each do |glyph|
            print "processing.. #{glyph}\r"
            sleep 0.15
          end
        end
      end
    end

    def normal
      @nogi.each do |name, comment, article|
        puts display_format("#{name.to_kanji}", comment, article)
      end
    end

    def sort_by_comment
      @nogi.sort_by { |_, b, _| b }.reverse_each do |name, comment, article|
        puts display_format("#{name.to_kanji}", comment, article)
      end
    end

    def sort_by_article
      @nogi.sort_by { |_, _, c| c }.reverse_each do |name, comment, article|
        puts display_format("#{name.to_kanji}", comment, article)
      end
    end

    def display_format(name, comment, article)
      name_length = 10 - full_width_count(name)
      [name.ljust(name_length), comment.to_s.rjust(7), article.to_s.rjust(7)].join(' | ')
    end

    def full_width_count(string)
      string.each_char.count { |char| !(/[ -~｡-ﾟ]/.match(char)) }
    end
  end
end
