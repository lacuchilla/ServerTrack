require 'rails_helper'

RSpec.describe Server, type: :model do
  server = Server.create(:name => 'Hello')

  context "initializing" do
      it "returns a Server object" do
        expect(server).to be_an_instance_of Server
      end
  end
end
