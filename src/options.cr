require "option_parser"
require "./macros"

module Options
  class OptionError < Exception
  end

  @args : Array(String)?

  macro def args : Array(String)
    begin
      @args ||= option_parser.parse(ARGV)
      return @args.not_nil!
    rescue err : ArgumentError | Options::OptionError | OptionParser::MissingOption
      STDERR.puts usage
      STDERR.puts
      STDERR.puts err.to_s
      exit -1
    ensure
      STDOUT.flush
      STDERR.flush
    end
  end

  macro option(declare, long_flag, description, default)
    var {{declare}}, {{default}}

    def register_option_{{declare.var.id}}(parser)
      {% if long_flag.stringify =~ /[\s=]/ %}
        {% if declare.type.stringify == "Int64" %}
          parser.on({{long_flag}}, {{description}}) {|x| self.{{declare.var}} = x.to_i64}
        {% elsif declare.type.stringify == "Int32" %}
          parser.on({{long_flag}}, {{description}}) {|x| self.{{declare.var}} = x.to_i32}
        {% elsif declare.type.stringify == "Int16" %}
          parser.on({{long_flag}}, {{description}}) {|x| self.{{declare.var}} = x.to_i16}
        {% else %}
          parser.on({{long_flag}}, {{description}}) {|x| self.{{declare.var}} = x}
        {% end %}
      {% else %}
        parser.on({{long_flag}}, {{description}}) {self.{{declare.var}} = true}
      {% end %}
    end
  end

  macro option(declare, short_flag, long_flag, description, default)
    var {{declare}}, {{default}}

    def register_option_{{declare.var.id}}(parser)
      {% if long_flag.stringify =~ /[\s=]/ %}
        {% if declare.type.stringify == "Int64" %}
          parser.on({{short_flag}}, {{long_flag}}, {{description}}) {|x| self.{{declare.var}} = x.to_i64}
        {% elsif declare.type.stringify == "Int32" %}
          parser.on({{short_flag}}, {{long_flag}}, {{description}}) {|x| self.{{declare.var}} = x.to_i32}
        {% elsif declare.type.stringify == "Int16" %}
          parser.on({{short_flag}}, {{long_flag}}, {{description}}) {|x| self.{{declare.var}} = x.to_i16}
        {% else %}
          parser.on({{short_flag}}, {{long_flag}}, {{description}}) {|x| self.{{declare.var}} = x}
        {% end %}
      {% else %}
        parser.on({{short_flag}}, {{long_flag}}, {{description}}) {self.{{declare.var}} = true}
      {% end %}
    end
  end

  macro options(*names)
    {% for name in names %}
      option_{{name.id.stringify.id}}
    {% end %}
  end

  @option_parser : OptionParser?
  
  protected def option_parser
    @option_parser ||= new_option_parser
  end

  macro def new_option_parser : OptionParser
    OptionParser.new.tap{|p|
      {% for name in @type.methods.map(&.name.stringify) %}
        {% if name =~ /\Aregister_option_/ %}
          {{name.id}}(p)
        {% end %}
      {% end %}
    }
  end

  macro usage(str)
    def usage
      {{str}}.sub(/^(Options:.*?)$/m){ "#{$1}\n#{new_option_parser}" }
    end
  end

  protected def die(reason : String)
    STDERR.puts reason.colorize(:red)
    STDERR.puts ""
    STDERR.puts usage
    STDERR.flush
    exit -1
  end
end
