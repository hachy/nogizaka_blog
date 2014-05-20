require 'nokogiri'
require 'open-uri'
require 'net/http'

module NogizakaBlog
  class Amazing
    using Extentions

    def initialize(yearmonth)
      @yearmonth = yearmonth
      @member_size = MEMBER.size
    end

    attr_reader :member_size

    def scraping
      get_max_page
      @member_max.each_with_index do |(name, max), idx|
        @comment = []

        # @comment = 0 when redirected
        if max == -1
          @comment << 0
        elsif max == 0
          url = "http://blog.nogizaka46.com/#{name}/?d=#{@yearmonth}"
          get_comment_size(url)
        else
          (1..max).each do |n|
            url = "http://blog.nogizaka46.com/#{name}/?p=#{n}&d=#{@yearmonth}"
            get_comment_size(url)
          end
        end

        if max == -1
          article = 0
        else
          article = @comment.length
        end

        yield name, @comment.sum, article, idx
      end
    end

    private

    def run
      puts "#{@yearmonth[0..3]}/#{@yearmonth[4..5]}"
      header = display_format('name', 'comment', 'article')
      puts header
      puts '-' * header.size
      scraping do |name, comment, article, _|
        puts display_format("#{name.to_kanji}(#{name})", comment, article)
      end
    end

    def gen_json
      last = @member_size - 1
      print "["
      scraping do |name, comment, article, idx|
        if idx == last
          print "{\"name\": \"#{name.to_kanji}\", \"comment\": #{comment}, \"article\": #{article}}"
        else
          print "{\"name\": \"#{name.to_kanji}\", \"comment\": #{comment}, \"article\": #{article}},"
        end
      end
      print "]"
    end

    def get_max_page
      nbsp = Nokogiri::HTML('&nbsp;').text
      @member_max = []

      MEMBER.keys.each do |name|
        url = "http://blog.nogizaka46.com/#{name}/?d=#{@yearmonth}"
        response = Net::HTTP.get_response(URI.parse(url))

        # Be redirected if it doesn't exist @yearmonth.
        case response
        when Net::HTTPSuccess
          doc = Nokogiri::HTML(open(url))
          paginate_class = doc.css('.paginate:first a:nth-last-child(2)')
          if paginate_class.empty?
            num = 0
          else
            paginate_class.each do |link|
              num = link.content
            end
            num.gsub!(nbsp, '')
          end
        when Net::HTTPRedirection
          num = -1
        end

        @member_max << [name, num.to_i]
      end
    end

    def get_comment_size(url)
      doc = Nokogiri::HTML(open(url))
      doc.css('.entrybottom a:last').each do |link|
        link.content.scan(/\d+/) { |c| @comment << c }
      end
    end

    def display_format(name, comment, article)
      name_length = 28 - full_width_count(name)
      [name.ljust(name_length), comment.to_s.rjust(7), article.to_s.rjust(7)].join(' | ')
    end

    def full_width_count(string)
      string.each_char.select { |char| !(/[ -~｡-ﾟ]/.match(char)) }.count
    end
  end
end
