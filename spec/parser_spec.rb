require 'spec_helper'

module Keepachangelog
  describe Parser do
    describe '.to_json' do
      it 'should cast parsed content into json' do
        p = Parser.new
        expect(p.parsed_content).to receive(:to_json)
        p.to_json
      end
    end

    describe '.to_yaml' do
      it 'should cast parsed content into yaml' do
        p = Parser.new
        expect(p.parsed_content).to receive(:to_yaml)
        p.to_yaml
      end
    end

    describe '.to_s' do
      it 'should cast parsed content into a string' do
        p = Parser.new
        expect(p.parsed_content).to receive(:to_s)
        p.to_s
      end
    end
  end
end
