# coding: utf-8
#
require 'spec_helper'

describe '3. プログラムと機能' do
  describe '3.1 プログラムと機能' do
    #describe package('Microsoft Visual C++ 2015-2019 Redistributable (x64) - 14.28.29913') do
    #  it { should be_installed }
    #end

    #describe package('Microsoft Visual C++ 2015-2019 Redistributable (x64) - 14.28.29913') do
    #  it { should be_installed }
    #end

    #describe package('VMWare Tools') do
    #  it { should be_installed }
    #end
  end

  describe '3.2 Windows Update 一覧' do
    describe windows_hot_fix('KB4589208') do
      it { should be_installed }
    end
    describe windows_hot_fix('KB5028168') do
      it { should be_installed }
    end
    describe windows_hot_fix('KB5028862') do
      it { should be_installed }
    end
    describe windows_hot_fix('KB5005112') do
      it { should be_installed }
    end
  end

end
