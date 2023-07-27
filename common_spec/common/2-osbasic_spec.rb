# coding: utf-8
require 'spec_helper'

describe '2. OS基本設定' do
  describe '2.1 サーバ基本情報' do
    # CPU論理コア数
    describe "CPU論理コア数" do
      describe command('Get-WmiObject -Class Win32_Processor | Format-List NumberOfLogicalProcessors') do
        its(:stdout) { should match /#{property[:cpucores]}/ }
      end
    end
    # メモリ容量
    describe "メモリ容量" do
      describe command('Get-WmiObject -Class Win32_PhysicalMemory') do
        its(:stdout) { should match /#{property[:memory]}/ }
      end
    end
  end

  #ディスク容量
  describe "2.2 ディスク容量" do
    describe '(1) ハードディスクの設定' do
      describe command('(Get-CimInstance -Class Win32_LogicalDisk)[0].Size/1GB') do
        it "100GB" do
          expect(subject.stdout.to_i).to be_within(100).of(200)
        end
      end
    end
  
    #デフラグスケジュール無効化
    describe '(2) デフラグスケージュール無効' do
      describe command('schtasks /Query /v /FO list /TN "\Microsoft\Windows\Defrag\ScheduledDefrag"') do
        its(:stdout) { should match /無効/ }
      end
    end
  end

  #ネットワーク設定
  describe '2.3 ネットワーク設定' do
    describe ' ネットワーク' do
      describe 'Microsoft ネットワーククライアント' do
        describe command('Get-NetAdapterBinding -ComponentID "ms_msclient"') do
          its(:stdout) { should match /True/ }
        end
      end

      describe 'Microsoft ネットワーク用ファイルとプリンター共有' do
        describe command('Get-NetAdapterBinding -ComponentID "ms_server"') do
          its(:stdout) { should match /True/ }
        end
      end

      describe 'QoSパケットスケジューラー' do
        describe command('Get-NetAdapterBinding -ComponentID "ms_pacer"') do
          its(:stdout) { should match /True/ }
        end
      end

      describe 'インターネットプロトコルバージョン4' do
        describe command('Get-NetAdapterBinding -ComponentID "ms_tcpip"') do
          its(:stdout) { should match /True/ }
        end
      end

      describe 'IPv4' do
        describe '優先DNSサーバ' do
          describe command("Get-DnsClientServerAddress -InterfaceAlias \"#{property[:interface]}\" -AddressFamily IPv4") do
            its(:stdout) { should match /#{property[:dnsserver]}/ }
          end
        end

        describe command("Get-NetIPConfiguration -detailed -AllCompartments -InterfaceAlias #{property[:interface]}") do
          its(:stdout) { should match /NetIPv4Interface.DHCP.*: Disabled/ }
          its(:stdout) { should match /DNSServer.*: #{property[:dnsserver]}/ }
          its(:stdout) { should match /IPv4Address.*: #{property[:ipaddress]}/ }
          its(:stdout) { should match /IPv4DefaultGateway.*: #{property[:defaultgw]}/ }
        end

        describe 'サブネットマスク' do
          describe command('(Get-WmiObject Win32_NetworkAdapterConfiguration).IPSubnet') do
            its(:stdout) { should match /255.255.255.0/ }
          end
        end

        describe 'DNS' do
          #
        end

        describe 'WINS設定' do
          describe 'LMHOSTの参照を有効にする' do
            describe windows_registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters') do
              it { should exist }
              it { should have_property_value('EnableLMHOSTS', :type_dword, '1')}
            end
          end
            
          describe command('ipconfig /all | Select-String NetBIOS') do
            its(:stdout) { should match /NetBIOS over TCP\/IP.*: 無効/ }
          end
        end

        describe command('Get-DnsClientGlobalSetting') do
          its(:stdout) { should contain('UseSuffixSearchList : False') }
          #its(:stdout) { should contain('SuffixSearchList.*: {cmn-card.corp}') }
        end
      end  # IPv4

      describe 'Microsoft Network Adapter Multiplexor Protocol' do
        describe command("Get-NetAdapterBinding -Name \"#{property[:interface]}\" -ComponentID \"ms_implat\"") do
          its(:stdout) { should match /False/ }
        end
      end

      describe 'Microsoft LLDP プロトコル　ドライバ' do
        describe command("Get-NetAdapterBinding -Name \"#{property[:interface]}\" -ComponentID \"ms_lldp\"") do
          its(:stdout) { should match /True/ }
        end
      end

      describe 'インターネットプロトコルバージョン6 (TCP/IPv6) ' do
        describe command("Get-NetAdapterBinding -Name \"#{property[:interface]}\" -ComponentID \"ms_tcpip6\"") do
          its(:stdout) { should match /False/ }
        end
      end

      describe 'Link-Layer Topology Discovery Responder' do
        describe command("Get-NetAdapterBinding -Name \"#{property[:interface]}\" -ComponentID \"ms_rspndr\"") do
          its(:stdout) { should match /True/ }
        end
      end

      describe 'Link-Layer Topology Discovery Mapper I/O Driver' do
        describe command("Get-NetAdapterBinding -ComponentID \"ms_lltdio\"") do
          its(:stdout) { should match /True/ }
        end
      end

      describe '(2) IPv6 ネットワークの無効化' do
        describe windows_registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters') do
          it { should exist }
          it { should have_property_value('DisabledComponents', :type_dword, 'ff') }
        end
      end

      describe 'ルーティングテーブル' do
        describe command('Get-NetRoute -DestinationPrefix "0.0.0.0/0"') do
          its(:stdout) { should match /#{property[:defaultgw]}/ }
        end
      end
    end
  end # ネットワーク設定
    
  describe '2.4 SNMP' do
    #サービスで実施、パッケージの確認必要？
  end

  describe '2.5 ドメイン／ワークグループ設定' do
    describe 'ドメイン名' do
      #describe command('Get-WmiObject Win32_NTDomain | Format-List DomainName') do
      #  its(:stdout) { should contain('#{property[:domainame]}') }
      #end
    end
    describe '保守用アカウント' do
      describe command('Get-WmiObject Win32_UserAccount | ? { $_.LocalAccount -eq $true } ') do
        its(:stdout) { should match /Administrator/ }
        #its(:stdout) { should contain("#{property[:localuser]}") }
      end
    end
  end    # ドメイン・ワークグループ

  describe '2.6 Windows ライセンス認証' do
    describe command('Get-CimInstance -ClassName SoftwareLicensingProduct | where { $_.PartialProductKey} | select ') do
      its(:stdout) { should match /1/ }
    end
  end

  describe '2.7 Windowsの起動と回復' do
    describe '起動システム' do
      describe '規定のオペレーティングシステム' do
        describe command('bcdedit | select-string "description"') do
          its(:stdout) { should match /Windows Server/ }
        end
      end
      describe 'オペレーティングシステムの一覧を表示する時間' do
        describe command('bcdedit') do
          its(:stdout) { should match /timeout.*0/ }
        end
      end
      describe '必要なときに修復オプションを表示する時間' do
        #    
      end
    end

    describe 'システムエラー' do
      describe 'システムログにイベントを書き込む' do
        describe command('Get-WmiObject Win32_OSRecoveryConfiguration | Select-Object "WriteToSystemLog"') do
          its(:stdout) { should match /True/ }
        end
      end
      describe '自動的に再起動する' do
        describe command('Get-WmiObject Win32_OSRecoveryConfiguration | Select-Object "AutoReboot"') do
          its(:stdout) { should match /True/ }
        end
      end
      describe 'デバッグ情報の書き込み' do
        describe command('Get-WmiObject Win32_OSRecoveryConfiguration | Select-Object "DebugInfoType"') do
          its(:stdout) { should match /1/ }
        end
      end
      describe 'カーネルダンプ' do
        describe command('Get-WmiObject Win32_OSRecoveryConfiguration | Select-Object "KernelDumpOnly"') do
          its(:stdout) { should match /False/ }
        end
      end
      describe 'ダンプファイル' do
        describe command('Get-WmiObject Win32_OSRecoveryConfiguration | Select-Object "DebugFilePath"') do
          its(:stdout) { should match /%SystemRoot%\\MEMORY.DMP/ }
        end
      end
      describe '既存のファイルに上書きする' do
        describe command('Get-WmiObject Win32_OSRecoveryConfiguration | Select-Object "OverwriteExistingDebugFile"') do
          its(:stdout) { should match /True/ }
        end
      end
      describe 'ディスク領域が少ない時でもメモリダンプの自動削除を無効にする' do
        describe windows_registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl') do
          it { should exist }
          it { should have_property_value('AlwaysKeepMemoryDump', :type_dword, '0') }
        end
      end
    end
  end # 2.7 起動と回復

  describe '2.8 ページングファイルサイズの管理' do
    describe 'すべてのドライブのページングファイルのサイズを自動的に管理する' do
      describe command('Get-WmiObject -Class Win32_ComputerSystem | Select-Object "AutomaticManagedPagefile"') do
        its(:stdout) { should match /False/ }
      end
    end
    describe command('Get-WmiObject Win32_PageFileSetting | Select-Object InitialSize') do
      its(:stdout) { should match /8449/ }
    end
    describe command('Get-WmiObject Win32_PageFileSetting | Select-Object MaximumSize') do
      its(:stdout) { should match /8449/ }
    end
  end # 2.8

  describe '2.9 イベントログ' do
    describe '最大ログサイズ' do
      describe command('Get-EventLog -List | Select-Object -property MaximumKilobytes,Log') do
        its(:stdout) { should match /32768 Application/ }
        its(:stdout) { should match /196608 Security/ }
        its(:stdout) { should match /32768 System/ }
        #its(:stdout) { should match /32768 Setup/ }   #不明（設定済み、取り出せない、使用可能だから？）
      end
      describe '「イベントログが最大値に達したとき」処理設定' do
        describe command('Get-EventLog -List | Select-Object OverflowAction,Log') do
          its(:stdout) { should match /OverwriteAsNeeded.*Application.*/ }
          its(:stdout) { should match /OverwriteAsNeeded.*Security.*/ }
          its(:stdout) { should match /OverwriteAsNeeded.*System.*/ }
          #its(:stdout) { should match /OverwriteAsNeeded.*Setup.*/ }    # リストされず
        end
      end
      describe 'ログのパス' do
        describe command('Get-WmiObject Win32_NTEventlogFile | Select-Object Caption' ) do
          #its(:stdout) { should match /C:\Windows\System32\Winevt\Logs\Application.evtx/ }
          #its(:stdout) { should contain('C:\Windows\System32\Winevt\Logs\Security.evtx') }
          #its(:stdout) { should contain('C:\Windows\System32\Winevt\Logs\Setup.evtx') }
          #its(:stdout) { should match /Setup.*\\windows\\system32\\winevt\\logs.*setup.evtx/ }
        end
      end

      describe 'ログを有効にする' do
        describe command('wevtutil gl Application | findstr enabled') do
          its(:stdout) { should contain('true') }
        end
        describe command('wevtutil gl Security | findstr enabled') do
          its(:stdout) { should contain('true') }
        end
        describe command('wevtutil gl System | findstr enabled') do
          its(:stdout) { should contain('true') }
        end
        describe command('wevtutil gl Setup | findstr enabled') do
          its(:stdout) { should contain('true') }
        end
      end
    end
  end # 2.9

  describe '2.10 リモートデスクトップ接続' do
    describe '(1) リモートデスクトップ接続の設定（RDP接続許可）' do
      describe 'このコンピュータへのリモート接続を許可する' do
        describe windows_registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server') do
          it { should exist }
          it { should have_property_value('fDenyTSConnections', :type_Dword, '0') }
        end

        describe command('Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections"') do
          its(:stdout) { should match /fDenyTSConnections : 0/ }
        end

        describe 'ネットワークレベル認証でリモートデスクトップを実行しているコンピュータからのみ接続を許可する' do
          describe windows_registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp') do
            it { should exist }
            it { should have_property_value('UserAuthentication',:type_dword, '1') }
          end
          describe command('Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication"') do
            its(:stdout) { should match /UserAuthentication : 1/ }
          end
        end
      end
    end

    describe '(2) リモートデスクトップ接続に使用するサーバー証明書' do
      # 
    end

    describe '(3) リモートデスクトップ接続に使用するサーバ証明書の指定' do
      #
    end
  end

  describe '2.11 Windowsファイアウォール' do
    describe command('Get-NetFirewallProfile | Select-Object Profile,Enabled') do
      its(:stdout) { should match /Domain.*False*/ }
      its(:stdout) { should match /Private.*False*/ }
      its(:stdout) { should match /Public.*False*/ }
    end
  end

  describe '2.12 Windows Update' do
    describe windows_registry_key('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
      it { should exist }
      it { should have_property_value('NoAutoUpdate', :type_dword, '1') }
    end
  end

  describe '2.13 Windows Defender' do
    describe service('Windows Defender Antivirus Service') do
      it { should_not be_running }
    end
    #describe windows_registry_key('HEKY_LOCAL_MACHINE\Software\Microsoft\Windows Defender') do
    #  it { should exist }
    #end
  end

  describe '2.14 Windowsエラー報告' do
    # サービスの停止確認
    describe service('WerSvc') do
      it { should_not be_running }
    end
    #describe windows_registry_key('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\Windows Error Reporting') do
    #  it { should exist }
    # 
    #it { should have_property_value('Disabled', :type_dword, '1') }
    #end
  end

  describe '2.15 ローカルセキュリティポリシー' do
    #
  end

  describe '2.16 NTPクライアント設定' do
    describe command('w32tm /query /configuration') do
      its(:stdout) { should match /NtpServer: time.windows.com,0x8/ }
      its(:stdout) { should match /Type: NTP/ }
    end
  end

  describe '2.17 host/servicesの設定' do
    describe file('C:\WINDOWS\SYSTEM32\DRIVERS\ETC\HOSTS') do
      its(:content) { should match /127.0.0.1/ }
    end
  end

  describe '2.18 SNP設定' do
    describe command('netsh int tcp show global') do
      its(:stdout) { should contain("Receive-Side Scaling 状態          : disabled") }
    end
  end

  describe '2.19 Proxy設定' do
    describe windows_registry_key('HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings') do
      #it { should have_property_value('AutoDetect', :type_dword, '0') }
      #it { should have_property_value('ProxyEnable', :type_sz, "#{property[:proxyipaddress]}") }
      #it { should have_property_value('ProxyOverride', :type_sz, "") }
    end
  end

  describe '2.20 `ローかるユーザとグループ' do
    describe command('Get-WmiObject Win32_GroupUser | Where-Object GroupCoponent -Like Administrators | Select-Object GroupComponent,PartComponent') do
      #its(:stdout) { should match /#{property[:localuser]}/ }
    end
  end

  describe '2.21 ローカルグループポリシー' do
    describe '(1) SMB署名有効化' do
      describe windows_registry_key('HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters') do
        it { should exist }
        it { should have_property_value('RequireSecuritySignature', :type_dword, '1')}
      end
    end

    describe '(2)暗号化スイート制限' do
      describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002') do
        it { should exist }
        it { should have_property_value('Functions', :type_string,'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CAMELLIA_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_CAMELLIA_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CCM,TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_CAMELLIA_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CAMELLIA_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_CCM,TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256,TLS_DHE_RSA_WITH_CAMELLIA_128_GCM_SHA256,TLS_DHE_RSA_WITH_AES_128_CCM,TLS_DHE_RSA_WITH_AES_128_CCM_8,TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_DHE_RSA_WITH_CAMELLIA_256_GCM_SHA384,TLS_DHE_RSA_WITH_AES_256_CCM,TLS_DHE_RSA_WITH_AES_256_CCM_8,TLS_DHE_RSA_WITH_CHACHA20_POLY1305_SHA256') }
      end
    end

    describe '(3) RDP複数セッション有効化' do
      describe windows_registry_key('HKEY_CURRENT_USER\Control Panel\Desktop') do
        it { should exist }
        it { should have_property_value('ScreenSaveActive', :type_sz, '1') }
      end

      describe windows_registry_key('HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop') do
        it { should exist }
        it { should have_property_value('ScreenSaveActive', :type_string, '1') }
        it { should have_property_value('ScreenSaveTimeOut', :type_string, '900') }
        it { should have_property_value('ScreenSaverIsSecure', :type_string, '1') }
      end
    end
  end # 2.21

  describe '2.22 SMB設定' do
    describe command('Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol') do
      its(:stdout) { should match /State.*: Disabled/ }
    end
    describe windows_registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters') do
      it { should have_property_value('SMB1', :type_dword, '0') }
    end
  end

  describe '2.23 IEセキュリティ強化の構成' do
    describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}') do
      it { should have_property_value('IsInstalled', :type_dword, '0') }
    end
    describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}') do
      it { should have_property_value('IsInstalled', :type_dword, '0') }
    end
  end
end
