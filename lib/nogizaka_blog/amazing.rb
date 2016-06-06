require 'nokogiri'
require 'open-uri'

module NogizakaBlog
  class Amazing
    include Enumerable
    using Extensions if RUBY_VERSION >= '2.1.0'

    attr_reader :member_size
    attr_accessor :yearmonth

    def initialize(yearmonth)
      @yearmonth = yearmonth
      @member_size = MEMBER.size
    end

    def scraping(&block)
      warn "\e[31m[DEPRECATION] `scraping` is deprecated.  Please use `each` instead.\e[0m"
      each(&block)
    end

    def each
      MEMBER.keys.each do |name|
        max = max_page(name)
        @comment = []

        # @comment = 0 when redirected
        if max == -1
          @comment << 0
        elsif max == 0
          url = "http://blog.nogizaka46.com/#{name}/?d=#{@yearmonth}"
          comment_size(url)
        else
          (1..max).each do |n|
            url = "http://blog.nogizaka46.com/#{name}/?p=#{n}&d=#{@yearmonth}"
            comment_size(url)
          end
        end

        if max == -1
          article = 0
        else
          article = @comment.length
        end

        yield name, @comment.sum, article
      end
    end

    private

    def max_page(name)
      nbsp = Nokogiri::HTML('&nbsp;').text
      url = "http://blog.nogizaka46.com/#{name}/?d=#{@yearmonth}"
      doc = Nokogiri::HTML(open(url, 'User-Agent' => 'firefox'))
      paginate_class = doc.css('.paginate:first a:nth-last-child(2)')
      paginate_class_last = doc.css('.paginate:first a:nth-last-child(1)')

      if paginate_class.empty?
        num = 0
      else
        # workaround
        if paginate_class_last.attribute('href').to_s == '?p=2'
          num = -1
        else
          paginate_class.each do |link|
            num = link.content
          end
          num.gsub!(nbsp, '')
        end
      end

      num.to_i
    end

    def comment_size(url)
      doc = Nokogiri::HTML(open(url, 'User-Agent' => 'firefox'))
      doc.css('.entrybottom a:last').each do |link|
        link.content.scan(/\d+/) { |c| @comment << c }
      end
    rescue => e
      puts "\e[31mSome failure: #{e}\e[0m"
    end
  end
end
