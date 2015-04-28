require 'helper'

describe 'configuration' do
  after do
    Rowling.reset
  end

  it "should set raw to false as the default" do
    Rowling.raw.must_equal false
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

