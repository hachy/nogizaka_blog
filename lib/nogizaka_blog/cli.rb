require 'optparse'

module NogizakaBlog
  OptionParser.new do |opt|
    opt.banner = "Usage: ruby nogizaka_blog.rb -m 201404"

    opt.on('-m [yearmonth]', "specify the month you want to get. ex. 201404") do |yearmonth|
      @yearmonth = yearmonth
      unless ARGV.include?("-j")
        nogizaka = NogizakaBlog::Amazing.new(@yearmonth)
        nogizaka.__send__ :run
      end
    end

    opt.on('-j', 'JSON format') do
      nogizaka = NogizakaBlog::Amazing.new(@yearmonth)
      nogizaka.__send__ :gen_json
    end

    opt.on_tail('-v', '--version', 'Show version') do
      puts "NogizakaBlog #{NogizakaBlog::VERSION}"
      exit
    end

    opt.parse!(ARGV)
  end
end
