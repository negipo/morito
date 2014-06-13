require 'spec_helper'

describe Morito::Client do
  let(:client) { described_class.new(user_agent) }

  describe '#allowed?' do
    subject { client.allowed?(requesting_url, cache: cache) }

    let(:cache) { true }

    context 'with response' do
      let(:body) do
        <<-EOS
User-agent: *
Disallow: /private

# Comment
User-agent: restricted agent # Comment
Disallow: /
EOS
      end

      before do
        stub_request(:any, //).to_return(body: body)
      end

      context 'with public path' do
        let(:requesting_url) { 'http://example.com/public/path' }

        context 'with some agent' do
          let(:user_agent) { 'some agent' }
          it { should == true }
        end

        context 'with restricted agent' do
          let(:user_agent) { 'restricted agent' }
          it { should == false }
        end

        context 'without cache' do
          let(:user_agent) { 'some agent' }
          let(:cache) { false }
          it { should == true }
        end
      end

      context 'with private path' do
        let(:requesting_url) { 'http://example.com/private/path' }

        context 'with some agent' do
          let(:user_agent) { 'some agent' }
          it { should == false }
        end

        context 'with restricted agent' do
          let(:user_agent) { 'restricted agent' }
          it { should == false }
        end
      end
    end

    context 'with 404' do
      let(:requesting_url) { 'http://example.com/public/path' }
      let(:user_agent) { 'restricted agent' }

      before do
        stub_request(:any, //).to_return(body: '', status: 404)
      end

      it { should == true }
    end
  end
end
