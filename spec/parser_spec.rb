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
      it 'should cast parsed content into a yaml files' do
        p = Parser.new
        expect_any_instance_of(YamlPrinter).to receive(:write)
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

    describe '.to_md' do
      it 'should cast parsed content into a Markdown document' do
        p = Parser.new
        expect_any_instance_of(MarkdownPrinter).to receive(:to_s)
        p.to_md
      end
    end
  end
end
