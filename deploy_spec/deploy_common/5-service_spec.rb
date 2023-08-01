# coding: utf-8
require 'spec_helper'

describe '5. サービス一覧' do
  describe '5.1 サービス一覧' do
    # 無効サービス
    describe service('ActiveX Installer (AxInstSV)') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Bluetooth オーディオ ゲートウェイ サービス') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Bluetooth サポート サービス') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Downloaded Maps Manager') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Geolocation Service') do
      it { should have_start_mode('Disabled') }
    end

    describe service('GraphicsPerfSvc') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Internet Connection Sharing (ICS)') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Link-Layer topology Discovery Mapper') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Microsoft Account Sign-in Assistant') do
      it { should have_start_mode('Disabled') }
    end

    # 無効化方法不明
    describe service('Microsoft Passport') do
      #it { should have_start_mode('Disabled') }
    end

    # 無効化方法不明
    describe service('Microsoft Passport Container') do
      #it { should have_start_mode('Disabled') }
    end

    describe service('Network Connection Broker') do
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
