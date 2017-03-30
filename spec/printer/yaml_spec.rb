require 'spec_helper'

module Keepachangelog
  describe YamlPrinter do
    let(:changelog) do
      {
        'versions' => {
          '1.0.0' => {
            'changes' => {
              'New' => [
                'Feature A',
                'Feature B'
              ],
              'Fixed' => ['Bug A']
            }
          },
          '1.0.1' => {
            'changes' => { 'Fixed' => ['Bug B'] }
          }
        },
        'url' => 'https://git.example.com/foo/bar',
        'title' => 'Change log',
        'intro' => 'This is my intro'
      }
    end
    let(:p) { YamlPrinter.new(changelog) }

    describe '.write' do
      before do
        allow(FileUtils).to receive(:mkdir_p).with('test')
        allow(FileUtils).to receive(:mkdir_p).with('test/1.0.0')
        allow(FileUtils).to receive(:mkdir_p).with('test/1.0.1')
        allow(File).to receive(:write).with('test/**/*.yaml', any_args)
      end

      it 'should create destination folder' do
        allow(p).to receive(:write_meta)
        allow(p).to receive(:write_versions)
        expect(FileUtils).to receive(:mkdir_p).with('test')
        p.write('test')
      end

      it 'should create meta file' do
        meta_content = "---\nurl: https://git.example.com/foo/bar\ntitle: "\
                       "Change log\nintro: This is my intro\n"
        allow(p).to receive(:write_versions)
        expect(File).to receive(:write).with('test/meta.yaml', meta_content)
        p.write('test')
      end

      it 'should create version folders' do
        allow(p).to receive(:write_meta)
        allow(p).to receive(:write_changes)
        expect(FileUtils).to receive(:mkdir_p).with('test/1.0.0')
        expect(FileUtils).to receive(:mkdir_p).with('test/1.0.1')
        p.write('test')
      end

      it 'should write change file' do
        allow(p).to receive(:write_meta)
        expect(File).to receive(:write).with(
          'test/1.0.0/feature-a.yaml',
          "---\ntitle: Feature A\ntype: New\n"
        )
        expect(File).to receive(:write).with(
          'test/1.0.0/feature-b.yaml',
          "---\ntitle: Feature B\ntype: New\n"
        )
        expect(File).to receive(:write).with(
          'test/1.0.0/bug-a.yaml',
          "---\ntitle: Bug A\ntype: Fixed\n"
        )
        expect(File).to receive(:write).with(
          'test/1.0.1/bug-b.yaml',
          "---\ntitle: Bug B\ntype: Fixed\n"
        )
        p.write('test')
      end
    end
  end
end
