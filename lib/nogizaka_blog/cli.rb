require 'thor'

module NogizakaBlog
  class CLI < Thor
    desc 'when YEARMONTH', 'Show the number of comments and articles'
    method_option :sort, aliases: '-s', desc: 'set comment or article'
    def when(yearmonth)
      @nogi = Amazing.new(yearmonth)
      print_header
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

    def normal
      @nogi.each do |name, comment, article|
        puts display_format("#{name.to_kanji}", comment, article)
      end
    end

    def sort_by_comment
      @nogi.sort { |a, b| b[1] <=> a[1] }.each do |name, comment, article|
        puts display_format("#{name.to_kanji}", comment, article)
      end
    end

    def sort_by_article
      @nogi.sort { |a, b| b[2] <=> a[2] }.each do |name, comment, article|
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
