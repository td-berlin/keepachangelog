require 'spec_helper'

describe Keepachangelog do
  describe '.version' do
    it 'returns the version of the gem' do
      expect(Keepachangelog.version).to match(/\d+\.\d+\.\d+.*/)
    end
  end
end
