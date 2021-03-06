require 'spec_helper'

describe 'jenkins::security', type: :class do
  let(:facts) do
    {
      osfamily: 'RedHat',
      operatingsystem: 'RedHat',
      operatingsystemrelease: '6.7',
      operatingsystemmajrelease: '6',
    }
  end

  let :params do
    {
      security_model: 'test'
    }
  end

  describe 'relationships' do
    it do
      should contain_class('jenkins::security').
        that_requires('Class[jenkins::cli_helper]')
    end
    it do
      should contain_class('jenkins::security').
        that_comes_before('Anchor[jenkins::end]')
    end

    it do
      should compile
    end
  end
end
