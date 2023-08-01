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

    describe service('Phone Service') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Print Spooler') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Printer Extensions and Notifications') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Program Compatibility Assistant Service') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Quality Windows Audio Video Experience') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Sensor Data Service') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Sensor Monitoring Service') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Sensor Service') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Shell Hardware Detection') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Smart Card Device Enumeration Service') do
      it { should have_start_mode('Disabled') }
    end

    describe service('SSDP Discovery') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Still Image Acquisition Events') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Touch Keyboard and Handwriting Panel Service') do
      it { should have_start_mode('Disabled') }
    end

    describe service('UPnP Device Host') do
      it { should have_start_mode('Disabled') }
    end

    describe service('WalletService') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Windows Audio') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Windows Audio Endpoint Builder') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Windows Image Acquisition (WIA)') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Windows Insider サービス') do
      it { should have_start_mode('Disabled') }
    end

    # WinRM テストと管理で使う
    describe service('Windows Remote Management (WS-Management)') do
      #it { should have_start_mode('Disabled') }
    end

    describe service('Windows カメラ フレーム サーバー') do
      it { should have_start_mode('Disabled') }
    end
    
    describe service('Windows プッシュ通知システム サービス') do
      it { should have_start_mode('Disabled') }
    end

    describe service('Windows モバイル ホットスポット サービス') do
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
