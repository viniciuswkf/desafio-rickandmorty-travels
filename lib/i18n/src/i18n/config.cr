require "./backend/base"
require "./config/plural_rules"

module I18n
  class Config
    @locale : String?
    @@backend : Backend::Base?
    @plural_rules = Hash(String, Proc(Int32, Symbol)).new

    # The only configuration value that is not global and scoped to thread is :locale.
    # It defaults to the default_locale.
    def locale
      @locale ||= default_locale
    end

    # Sets the current locale pseudo-globally, i.e. in the Thread.current hash.
    def locale=(locale)
      @locale = locale
    end

    def plural_rules
      @plural_rules
    end

    # Search for pluralization rule for provided locale
    def plural_rule_for(locale) : Proc(Int32, Symbol)
      if DEFAULT_PLURAL_RULES.has_key?(locale)
        DEFAULT_PLURAL_RULES[locale][:rule]
      elsif @plural_rules.has_key?(locale)
        @plural_rules[locale]
      else
        COMMON_PLURAL_RULES[:default][:rule]
      end
    end

    # Returns the available locales
    def available_locales : Array(String)
      backend.available_locales
    end

    # Returns the current backend.
    def backend
      @@backend ||= Backend::Yaml.new
    end

    # Sets the current backend. Used to set a custom backend.
    def backend=(backend)
      @@backend = backend
    end

    # Returns the current default locale. Defaults to :'en'
    def default_locale
      @@default_locale ||= "en"
    end

    def default_locale=(new_default : String)
      @@default_locale = new_default if available_locales.includes? new_default
    end

    # Returns the current default scope separator. Defaults to '.'
    def default_separator
      @@default_separator ||= '.'
    end

    # Sets the current default scope separator.
    def default_separator=(separator)
      @@default_separator = separator
    end

    # Returns the current exception handler. Defaults to an instance of
    # I18n::ExceptionHandler.
    def exception_handler
      @@exception_handler ||= ExceptionHandler.new
    end

    # Sets the exception handler.
    def exception_handler=(exception_handler)
      @@exception_handler = exception_handler
    end

    # Allow clients to register paths providing translation data sources. The
    # backend defines acceptable sources.
    #
    # E.g. the provided SimpleBackend accepts a list of paths to translation
    # files which are either named *.rb and contain plain Ruby Hashes or are
    # named *.yml and contain YAML data. So for the SimpleBackend clients may
    # register translation files like this:
    #   I18n.load_path << 'path/to/locale/en.yml'
    def load_path
      @@load_path ||= [] of String
    end

    # Sets the load path instance. Custom implementations are expected to
    # behave like a Ruby Array.
    def load_path=(load_path)
      @@load_path = load_path
    end
  end
end
