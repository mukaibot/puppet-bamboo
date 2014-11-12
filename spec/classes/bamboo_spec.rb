require 'spec_helper'

describe 'bamboo on unsupported platform' do
  let(:facts) {{ :osfamily => 'Windows' }}
  #it { should_not compile }
end

describe 'bamboo' do

  # Update the bamboo version
  bamboo_version = '5.7.0'

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
        it {should contain_class('bamboo') }
        it {should contain_class('bamboo::params') }

        it {should contain_class('bamboo::user') }
        it {should contain_user('bamboo').with_home('/opt/atlassian/bamboo')}
        it do
          should contain_exec('Make home parent if needed').with({
            :command => /\/opt\/atlassian/,
            :creates => '/opt/atlassian',
          })
        end
        it do
          should contain_file('/opt/atlassian/bamboo/logs').with({
            :ensure => 'directory',
            :owner  => 'bamboo',
            :group  => 'bamboo',
            :mode   => '0755'
          })
        end

        it {should contain_class('bamboo::java') }

        it {should contain_class('bamboo::database') }
        it {should contain_class('bamboo::database::postgresql') }

        it {should contain_class('postgresql::server') }
        it {should contain_postgresql__server__role('bamboo') }
        it {should contain_postgresql__server__db('bamboo') }
        it {should contain_postgresql__server__database('bamboo') }
        it {should contain_postgresql__server__database_grant('GRANT bamboo - ALL - bamboo') }

        it {should contain_class('bamboo::install') }
        it do
          should contain_staging__deploy("bamboo-#{bamboo_version}.tar.gz").with({
            :user   => 'bamboo',
            :group  => 'bamboo',
          })
        end
        it do
          should contain_exec('make bamboo data dir').with({
            :command => /\/var\/atlassian\/application-data\/bamboo/,
            :creates => '/var/atlassian/application-data/bamboo'
          })
        end
        it do
          should contain_file('/var/atlassian/application-data/bamboo').with({
            :ensure => 'directory',
            :owner  => 'bamboo',
            :group  => 'bamboo',
            :mode   => '0755',
          })
        end
        it do
          should contain_file('/opt/atlassian/bamboo/current').with({
            :ensure => 'link',
            :target => "/opt/atlassian/bamboo/atlassian-bamboo-#{bamboo_version}",
          })
        end
        it do
          should contain_file_line('Set bamboo data directory').with({
            :ensure => 'present',
            :path   => '/opt/atlassian/bamboo/current/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties',
            :line   => "bamboo.home=/var/atlassian/application-data/bamboo\n",
          })
        end

        it {should contain_class('bamboo::service') }
        it do
          should contain_file('/etc/init.d/bamboo').with({
            :ensure => 'file',
            :content => /bamboo/,
          })
        end
        it do
          should contain_service('bamboo').with({
            :ensure => 'running',
            :enable => true,
          })
        end

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
      end
    end
  end
end
