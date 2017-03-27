require 'spec_helper'

module Keepachangelog
  describe MarkdownParser do
    describe '.parse' do
      it 'should parse empty content' do
        cl = MarkdownParser.parse('')
        expect(cl).to eq('versions' => {})
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
        cl = MarkdownParser.parse(content)
        expect(cl).to eq(
          'versions' => {
            '1.2.3' => {
              'url' => 'http://test.io',
              'date' => '2017-01-01',
              'changes' => {
                'New' => ['Feature A'],
                'Fixed' => ['Feature B']
              }
            }
          }
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
        cl = MarkdownParser.parse(content)
        expect(cl).to eq(
          'versions' => {
            '2.0.0' => {
              'url' => nil,
              'date' => '2017-01-01',
              'changes' => { 'New' => ['Feature A'] }
            },
            '1.0.0' => {
              'url' => 'http://test.io',
              'date' => nil,
              'changes' => { 'Fixed' => ['Feature B'] }
            }
          }
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
        cl = MarkdownParser.parse(content)
        expect(cl).to eq(
          'versions' => {
            '3.0.0' => {
              'url' => nil, 'date' => nil, 'changes' => {}
            },
            '2.0.0' => {
              'url' => nil,
              'date' => '2017-01-01',
              'changes' => { 'New' => ['Feature A'] }
            },
            '1.0.0' => {
              'url' => nil, 'date' => nil, 'changes' => {}
            }
          }
        )
      end
    end

    describe '.load' do
      it 'should parse content of file' do
        content = 'test changelog'
        allow(File).to receive(:open).and_call_original
        expect(File).to receive(:open).with('test.md')
          .and_yield(StringIO.new(content))
        expect_any_instance_of(MarkdownParser).to receive(:parse).with(content)
        MarkdownParser.load('test.md')
      end

      it 'should throw on non-existent file' do
        expect do
          MarkdownParser.load('invalid-file')
        end.to raise_exception(
          Errno::ENOENT,
          'No such file or directory @ rb_sysopen - invalid-file'
        )
      end
    end
  end
end
