require 'rails_helper'

RSpec.describe ServersController, :type => :controller do
  let(:fred) {Server.create(:name => "Fred")}
  let(:keys)  { ["name", "created_at", "updated_at"] }

  describe "GET 'index'" do
      it "is successful" do
        get :index
        expect(response.response_code).to eq 200
      end

      it "returns json" do
        get :index
        expect(response.header['Content-Type']).to include 'application/json'
      end

      context "the returned json object" do
        before :each do
          fred
          get :index
          @response = JSON.parse response.body
        end

        it "is an array of server objects" do
          expect(@response).to be_an_instance_of Array
          expect(@response.length).to eq 2
        end

        it "includes only the name, created at and updated at keys" do
          expect(@response.map(&:keys).flatten.uniq.sort).to eq keys
        end
      end
    end

    describe "GET 'show'" do
      it "is successful" do
        get :show, id: fred.id
        expect(response.response_code).to eq 200
      end

      it "returns json" do
        get :show, id: fred.id
        expect(response.header['Content-Type']).to include 'application/json'
      end

      context "the returned json object" do
        before :each do
          get :show, id: fred.id
          @response = JSON.parse response.body
        end

        it "has the right keys" do
          expect(@response.keys.sort).to eq keys
        end

        it "has all of Fred's info" do

            expect(@response[:name]).to eq "Fred"

        end
      end

      context "no servers found" do
        before :each do
          get :show, id: 1000
        end

        it "is successful" do
          expect(@response).to be_successful
        end

        it "returns a 204 (no content)" do
          expect(@response.response_code).to eq 204
        end

        it "expects the response body to be an empty array" do
          expect(@response.body).to eq "{}"
        end
      end
  end
end
