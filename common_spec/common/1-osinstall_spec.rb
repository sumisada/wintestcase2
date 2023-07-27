# coding: utf-8
require 'spec_helper'

describe '1. OSインストール' do
  describe '1.1 Windows Server 2019 Standard Install' do
    describe ' Lanugage' do
      describe command('dism /online /get-intl') do
        #its(:stdout) { should contain("#{property[:language]}") }
        its(:stdout) { should contain("既定のシステム UI 言語 : ja-JP")}
      end
    end

    describe 'キーボードの種類' do
      describe command('Get-WmiObject Win32_Keyboard') do
        #its(:stdout) { should contain("拡張 (101- または 102-key)") }
        its(:stdout) { should contain("00000411") }
      end
    end

    describe "1.2 OSバージョン" do
      describe "Windowsのバージョン情報" do
        describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion') do
          it { should exist }
          it { should have_property_value('CurrentBuild', :type_string, "#{property[:currentbuild]}" ) }
          it { should have_property_value('ReleaseID', :type_sz, "#{property[:releaseid]}" ) }
        end
      end

      describe "OSビルド" do
        describe command('cmd') do
          its(:stdout) { should contain("#{property[:osversion]}") }
        end
      end
    end

    # 簡易テスト
    describe 'ホスト名' do
      describe command('hostname') do
        its(:stdout) { should match /#{property[:hostname]}/ }
      end
    end

    describe 'IPアドレス' do
      describe command("ipconfig") do
        its(:stdout) { should contain("#{property[:ipaddress]}") }
      end
    end
  end
end
