require 'spec_helper'

module Keepachangelog
  describe MarkdownPrinter do
    describe '.to_s' do
      it 'should print markdown document' do
        versions = {
          '1.0.0' => {
            'changes' => { 'New' => ['Feature A'] }
          }
        }
        p = MarkdownPrinter.new(versions, title: 'My Title')
        md = p.to_s
        expect(md).to match('# My Title')
        expect(md).to match('## 1.0.0')
      end

      it 'should order versions numerically' do
        versions = {
          '0.1.0' => {
            'changes' => { 'New' => ['Feature A'] }
          },
          'foo bar' => {
            'changes' => { 'New' => ['Feature D'] }
          },
          '0.10.0' => {
            'changes' => { 'New' => ['Feature B'] }
          },
          '0.2.0' => {
            'changes' => { 'New' => ['Feature C'] }
          }
        }
        p = MarkdownPrinter.new(versions, url: 'test.io')
        md = p.to_s.delete("\n")
        expect(md).to match(/0\.10\.0.*0\.2\.0.*0\.1\.0/)
        expect(md).to match('test.io/compare/0.1.0...0.2.0')
        expect(md).to match('test.io/compare/0.2.0...0.10.0')
        expect(md).to match('test.io/compare/0.10.0...HEAD')
      end

      it 'should order sections explicitly' do
        versions = {
          '0.1.0' => {
            'changes' => {
              'Fixed' => ['Feature A'],
              'Changed' => ['Feature B'],
              'Added' => ['Feature C'],
              'Removed' => ['Feature D']
            }
          }
        }
        order = %w[Added Changed Removed Fixed]
        p = MarkdownPrinter.new(versions, url: 'test.io', section_order: order)
        md = p.to_s.delete("\n")
        expect(md).to match(/Added.*Changed.*Removed.*Fixed/)
      end

      it 'should order changes alphabetically' do
        versions = {
          '0.1.0' => {
            'changes' => {
              'Added' => %w[
                FeatureB
                FeatureA
                FeatureC
              ]
            }
          }
        }
        p = MarkdownPrinter.new(versions, url: 'test.io')
        md = p.to_s.delete("\n")
        expect(md).to match(/FeatureA.*FeatureB.*FeatureC/)
      end
    end
  end
end
