module UsatodayBestsellers
  class Client
    attr_accessor *Configuration::CONFIGURATION_KEYS

    def initialize(options={})
      Configuration::CONFIGURATION_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
  end
end
