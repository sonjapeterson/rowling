require 'helper'

describe UsatodayBestsellers::Client do

  it "should configure valid configuration keys" do
    client = UsatodayBestsellers::Client.new(api_key: "my_secret_key", format: :json)
    client.api_key.must_equal "my_secret_key"
    client.format.must_equal :json
  end

end
