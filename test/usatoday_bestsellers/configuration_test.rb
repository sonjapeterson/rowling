require 'helper'

describe 'configuration' do
  after do
    UsatodayBestsellers.reset
  end

  it "should set json as the default format" do
    UsatodayBestsellers.format.must_equal :json
  end

  it "should set the api key's default value as nil" do
    UsatodayBestsellers.api_key.must_equal nil
  end

  it "should allow you to set an api key" do
    UsatodayBestsellers.configure do |config|
      config.api_key = "my_secret_key"
    end
    UsatodayBestsellers.api_key.must_equal "my_secret_key"
  end
end

