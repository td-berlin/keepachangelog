require 'spec_helper'

module Keepachangelog
  describe Parser do
    describe '#parse' do
      it 'should parse empty content' do
        content = ''
        p = Parser.new(content)
        expect(p.parsed_content).to eq([])
      end

      it 'should parse single version' do
        content = "
        ## [1.2.3] - 2017-01-01
        ### New
        - Feature A
        ### Fixed
        - Feature B
        [1.2.3]: http://test.io
        "
        p = Parser.new(content)
        expect(p.parsed_content).to eq(
          [
            {
              'version' => '1.2.3',
              'url' => 'http://test.io',
              'date' => '2017-01-01',
              'changes' => {
                'New' => ['Feature A'],
                'Fixed' => ['Feature B']
              }
            }
          ]
        )
      end

      it 'should parse multiple versions' do
        content = "
        ## [2.0.0] - 2017-01-01
        ### New
        - Feature A
        ## [1.0.0]
        ### Fixed
        - Feature B
        [1.0.0]: http://test.io
        "
        p = Parser.new(content)
        expect(p.parsed_content).to eq(
          [
            {
              'version' => '2.0.0',
              'url' => nil,
              'date' => '2017-01-01',
              'changes' => { 'New' => ['Feature A'] }
            },
            {
              'version' => '1.0.0',
              'url' => 'http://test.io',
              'date' => nil,
              'changes' => { 'Fixed' => ['Feature B'] }
            }
          ]
        )
      end

      it 'should parse version without sections' do
        content = "
        ## [3.0.0]
        ## [2.0.0] - 2017-01-01
        ### New
        - Feature A
        ## [1.0.0]
        "
        p = Parser.new(content)
        expect(p.parsed_content).to eq(
          [
            {
              'version' => '3.0.0', 'url' => nil, 'date' => nil,
              'changes' => {}
            },
            {
              'version' => '2.0.0',
              'url' => nil,
              'date' => '2017-01-01',
              'changes' => { 'New' => ['Feature A'] }
            },
            {
              'version' => '1.0.0', 'url' => nil, 'date' => nil,
              'changes' => {}
            }
          ]
        )
      end
    end

    describe '.load' do
      it 'should parse content of file' do
        content = 'test changelog'
        allow(File).to receive(:open).and_call_original
        expect(File).to receive(:open).with('test.md')
          .and_yield(StringIO.new(content))
        expect(Parser).to receive(:new).with(content)
        Parser.load('test.md')
      end

      it 'should throw on non-existent file' do
        expect do
          Parser.load('invalid-file')
        end.to raise_exception(
          Errno::ENOENT,
          'No such file or directory @ rb_sysopen - invalid-file'
        )
      end
    end

    describe '.parse' do
      it 'should call on .new' do
        expect(Parser).to receive(:new).with('test')
        Parser.parse('test')
      end
    end

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
