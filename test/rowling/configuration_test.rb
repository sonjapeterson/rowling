require 'helper'

describe 'configuration' do
  after do
    Rowling.reset
  end

  it "should set json as the default format" do
    Rowling.format.must_equal :json
  end

  it "should set the api key's default value as nil" do
    Rowling.api_key.must_equal nil
  end

  it "should allow you to set an api key" do
    Rowling.configure do |config|
      config.api_key = "my_secret_key"
    end
    Rowling.api_key.must_equal "my_secret_key"
  end
end

