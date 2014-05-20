require 'thor'

module NogizakaBlog
  class CLI < Thor
    desc "yearmonth YEARMONTH", "show the number of comments and articles of Nogizaka46's blog"
    option :json, :type => :boolean, :aliases => '-j'
    def yearmonth(ym)
      nogizaka = NogizakaBlog::Amazing.new(ym)
      if options[:json]
        nogizaka.__send__ :gen_json
      else
        nogizaka.__send__ :run
      end
    end
    map %w(-ym --yearmonth) => :yearmonth

    desc "version", "show NogizakaBlog version"
    def version
      puts "NogizakaBlog #{NogizakaBlog::VERSION}"
    end
    map %w(-v --version) => :version
  end

  CLI.start(ARGV)
end
