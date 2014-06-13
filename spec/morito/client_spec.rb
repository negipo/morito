require 'spec_helper'

describe Morito::Client do
  before do
    stub_request(:any, //).to_return(body: body)
  end

  let(:client) { described_class.new(user_agent) }
  let(:body) do
    <<-EOS
User-agent: *
Disallow: /private

User-agent: restricted agent # Comment
Disallow: /
EOS
  end

  describe '#allowed?' do
    subject { client.allowed?(requesting_url) }

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
end
