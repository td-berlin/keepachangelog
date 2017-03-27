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
    end
  end
end
