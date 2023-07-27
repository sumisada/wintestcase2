# coding: utf-8
require 'spec_helper'

describe '5. サービス一覧' do
  describe '5.1 サービス一覧' do
    describe service('ActiveX Installer (AxInstSV)') do
      it { should have_start_mode('Disabled') }
    end


    describe service('AllJoyn Router Service') do
      it { should have_start_mode('Manual') }
    end

    describe service('Background Tasks Infrastructure Service') do
      it { should have_start_mode('Automatic') }
    end

  end
end
