# coding: utf-8
require 'spec_helper'

describe '4. 役割と機能' do
  describe 'サービス有効確認' do
    describe command('Get-WindowsFeature | where-object {$_.Installed -eq $True} | where-object Name -eq "SNMP-Service"') do
      its(:stdout) { should match /SNMP サービス/ }
    end

    describe command('Get-WindowsFeature | where-object Name -eq "RSAT"') do
      its(:stdout) { should match /リモート サーバー管理ツール/ }
    end

    describe command('Get-WindowsFeature | where-object Name -eq "RSAT-Feature-Tools"') do
      its(:stdout) { should match /機能管理ツール/ }
    end

    describe command('Get-WindowsFeature | where-object Name -eq "RSAT-SNMP"') do
      its(:stdout) { should match /SNMP ツール/ }
    end

    describe command('Get-WindowsFeature | where-object Name -eq "FileAndStorage-Services"') do
      its(:stdout) { should match /ファイル サービスと記憶域サービス/ }
    end

  end
end
