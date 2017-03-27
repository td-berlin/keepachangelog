require 'spec_helper'

module Keepachangelog
  describe YamlParser do
    describe '.parse' do
      it 'should parse empty content' do
        cl = YamlParser.parse('')
        expect(cl).to eq({})
      end

      it 'should parse single version' do
        content = "
---
title: Feature A
type: New
"
        cl = YamlParser.parse(content, '1.2.3')
        expect(cl).to eq(
          '1.2.3' => {
            'changes' => {
              'New' => ['Feature A']
            }
          }
        )
      end
    end

    describe '.load' do
      it 'should parse content of folder' do
        content = 'test changelog'
        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).with('changelog/1.0.0/1.yml')
          .and_yield(StringIO.new(content))
        expect(Dir).to receive(:glob).with('changelog/*')
          .and_return(['changelog/1.0.0'])
        expect(Dir).to receive(:glob).with('changelog/1.0.0/**/*.yml')
          .and_return(['changelog/1.0.0/1.yml'])
        expect(Dir).to receive(:glob).with('changelog/1.0.0/**/*.yaml')
          .and_return([])

        expect_any_instance_of(YamlParser).to \
          receive(:parse).with('test changelog', '1.0.0')

        YamlParser.load
      end
    end
  end
end
