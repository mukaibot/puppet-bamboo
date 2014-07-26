require 'spec_helper'

describe 'bamboo on unsupported platform' do
  let(:facts) {{ :osfamily => 'Windows' }}
  it { should_not compile}
end

describe 'bamboo' do
  ['RedHat', 'Debian' ].each do |osfamily|

    if osfamily == 'RedHat'
      [ 'RedHat', 'CentOS' ].each do |operatingsystem|
        let(:facts) {{ 
          :osfamily               => osfamily,
          :operatingsystem        => operatingsystem,
          :operatingsystemrelease => '6.5',
          :concat_basedir         => '/tmp/concat_spec',
        }}
      end
    end

    if osfamily == 'Debian'
      [ 'wheezy', 'jessie', 'precise','quantal','raring','saucy', 'trusty' ].each do |lsbdistcodename|
        let(:facts) {{
          :osfamily         => osfamily,
          :lsbdistid        => osfamily.downcase,
          :lsbdistcodename  => lsbdistcodename,
          :concat_basedir   => '/tmp/concat_spec',
        }}
      end
    end

    describe "on #{osfamily}" do
      describe "with default arguments" do
        it {should contain_class('bamboo::user') }
        it {should contain_class('bamboo::java') }
        it {should contain_class('bamboo::database') }
        it {should contain_class('bamboo::install') }
        it {should contain_class('bamboo::service') }
      end

      describe "with java_manage == false" do
        let(:params) {{ :java_manage => false }}
        it { should_not contain_class('java') }
      end

      describe "with db_manage == false" do
        let(:params) {{ 
          :db_manage  => false,
          :db_type    => 'postgresql',
        }}
        it { should_not contain_class('postgresql::server') }
      end

      describe "with db_type == mysql" do
        let(:params) {{
          :db_manage  => true,
          :db_type    => 'mysql',
        }}
        it { expect { should_not compile } }
        #it { expect { should_not compile }.to raise_error(Puppet::Error, /Error: MySQL/) }
      end
    end
  end
end
