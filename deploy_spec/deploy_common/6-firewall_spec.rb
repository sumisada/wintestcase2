# coding: utf-8
require 'spec_helper'

describe '6. Windows ファイアウォール' do
  describe command('netsh advfirewall show domainprofile state') do
    its(:stdout) { should match /State.*オフ/ }
  end
  describe command('netsh advfirewall show publicprofile state') do
    its(:stdout) { should match /State.*オフ/ }
  end
  describe command('netsh advfirewall show privateprofile state') do
    its(:stdout) { should match /State.*オフ/ }
  end
end
