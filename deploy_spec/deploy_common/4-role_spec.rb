# coding: utf-8
require 'spec_helper'

describe '4. 役割と機能' do
  describe 'サービス有効確認' do
    describe command('Get-WindowsFeature | where-object {$_.Installed -eq $True} | where-object Name -eq "SNMP-Service"') do
      its(:stdout) { should match /SNMP サービス/ }
    end

  end
end
