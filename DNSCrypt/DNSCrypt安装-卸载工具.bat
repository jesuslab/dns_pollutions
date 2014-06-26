cls&@echo off&color 2f&cd /d %~dp0

Set Prog=瓦斯曲 DNSCrypt安装-卸载工具
Set L1=　　　　　　　　　　╭───────────────╮
Set L2=　　　　　　╭───┤ %Prog% ├───╮
Set L3=　　　　　　│　　　╰───────────────╯　　  │
Set L4=　　　　　　│==============================================│
Set L5=　　　　　　│注：运行后请重新启动计算机，保证配置生效！    │
Set L6=　　　　　　│    如果是Windows 7 请以管理员身份运行本脚本！│
Set L7=　　　　　　╰───────────────────────╯

:主菜单
cls&@echo off&color 2f
Title %Prog%_主菜单
Echo.
Echo %L1%
Echo %L2%
Echo %L3%
Echo             │                                              │
Echo 　　　　　　│　(1) 查看DNS配置  (看是否已安装、正确配置)   │
Echo             │                                              │
Echo 　　　　　　│　(2) 安装DNSCrypt服务                        │
Echo             │                                              │
Echo 　　　　　　│　(3) 卸载DNSCrypt服务　　　　　　　　　　　　│
Echo             │                                              │
Echo             │  (4) DNSCrypt说明                            │
Echo             │                                              │
Echo %L4%
Echo %L5%
Echo %L6%
Echo %L7%

echo.
SET /P psn=                请输入 ( ) 中的数字键并按回车:
if /I "%psn%"=="1" goto 状态
if /I "%psn%"=="2" goto 安装
if /I "%psn%"=="3" goto 卸载
if /I "%psn%"=="4" cls&more +113 %~0 &pause&goto :主菜单

:返回
goto 主菜单


:状态
cls
color 0f
Title 当前DNS配置状态
echo =============================================
echo dnscrypt-proxy服务状态
echo =============================================
rem net start|findstr "dnscrypt"
sc query dnscrypt-proxy
echo =============================================
echo 当前DNS配置
echo =============================================
netsh interface ipv show dnsservers
echo --------------------------------------------
echo ipv6 show dnsservers
echo --------------------------------------------
netsh interface ipv6 show dnsservers

echo.现在按任意键返回主菜单。
pause >nul
goto 主菜单

:安装
cls
color 0b
Title %Prog%_安装dnscrypt-proxy服务
echo.正在安装dnscrypt-proxy服务...
echo.
net stop dnscrypt-proxy
dnscrypt-proxy.exe --install
echo.设置本地连接 DNS……
netsh interface ip set dns name="本地连接" source=static addr=127.0.0.1 register=PRIMARY
netsh interface ip add dns name="本地连接" addr=1.2.4.8
netsh interface ip add dns name="本地连接" addr=8.8.8.8
netsh interface ipv6 delete dnsservers "本地连接" all
netsh interface ipv6 add dnsservers "本地连接" ::1
netsh interface ipv6 add dnsservers "本地连接" 2001:4860:4860::8888


echo.设置无线网络连接 DNS……
netsh interface ip set dns name="无线网络连接" source=static addr=127.0.0.1 register=PRIMARY
netsh interface ip add dns name="无线网络连接" addr=1.2.4.8
netsh interface ip add dns name="无线网络连接" addr=8.8.8.8
netsh interface ipv6 delete dnsservers "无线网络连接" all
netsh interface ipv6 add dnsservers "无线网络连接" ::1
netsh interface ipv6 add dnsservers "无线网络连接" 2001:4860:4860::8888


echo.刷新 DNS配置……
ipconfig /flushdns
echo.安装完成！请按任意键退出。
pause >nul
goto :eof

:卸载
cls
color 0d
Title %Prog%_卸载dnscrypt-proxy服务...
echo.
echo.正在卸载dnscrypt-proxy服务...
net stop dnscrypt-proxy
dnscrypt-proxy.exe --uninstall
echo.设置本地连接 DNS……
netsh interface ip set dns name="本地连接" source=static addr=1.2.4.8 register=PRIMARY
netsh interface ip add dns name="本地连接" addr=8.8.8.8
netsh interface ipv6 delete dnsservers "本地连接" all
netsh interface ipv6 add dnsservers "本地连接" 2001:4860:4860::8888

echo.设置无线网络连接 DNS……
netsh interface ip set dns name="无线网络连接" source=static addr=1.2.4.8 register=PRIMARY
netsh interface ip add dns name="无线网络连接" addr=8.8.8.8
netsh interface ipv6 delete dnsservers "无线网络连接" all
netsh interface ipv6 add dnsservers "无线网络连接" 2001:4860:4860::8888

echo.刷新 DNS配置……
ipconfig /flushdns

echo.
echo.dnscrypt-proxy服务卸载完成！请按任意键退出。
echo.
pause >nul
goto :eof

==============================================================
DNSCrypt：用于在客户端和DNS解析器之间的安全通信的工具
==============================================================

官方地址：http://dnscrypt.org/
项目维护jedisct1托管在GitHub上页-主题由mattgraham

描述
dnscrypt代理提供了可以直接作为你的本地域名解析或D??NS转发，加密和认证使用DNSCrypt协议的请求，并将其传递到上游服务器的本地服务。

该DNSCrypt协议采用高速高安全性的椭圆曲线加密算法和非常相似DNSCurve，而是侧重于保护客户端和它的第一级分解器之间的通信。

虽然没有提供端至端的安全性，它可以保护本地网络，这往往是最薄弱的环节链的同时，对人在这方面的中间人攻击。它还提供了一些保密的DNS查询。

下载：
DNSCrypt可以在这里下载：http://dnscrypt.org/dnscrypt-proxy/downloads/

适用于Windows
请下载：dnscrypt-proxy-win32-1.3.3.zip 
安装为服务（仅适用于Windows）
代理可以安装为Windows服务。

复制dnscrypt-proxy.exe文件到任意位置，以及相关的libsodium-4.dll文件，它们都应该在相同的位置。然后打开一个终端，输入（最终与完整路径 dnscrypt-proxy.exe）：

dnscrypt-proxy.exe --install
它会安装一个名为新的服务dnscrypt代理。

在停止后，该服务可与被删除：

dnscrypt-proxy.exe --uninstall
请参阅使用DNSCrypt在Windows文件查找有关此主题的更多信息。

HOSTIP工具
该DNSCrypt代理附带了一个简单的工具名为HOSTIP解析一个名称为IPv4或IPv6地址。
==============================================================
DNSCrypt解析器当前列表
==============================================================
OKTurtles（无日志） -的一部分DNSChain项目。
服务器地址
23.226.227.93:443
提供者名称
2.dnscrypt-cert.okturtles.com
公钥
1D85：3953：E34F：AFD0：05F9：4C6F：D1CC：E635：D411：9904:0 D48：D19A：5D35：0B6A：7C81：73CB

OpenDNS的
服务器地址
208.67.220.220:443
提供者名称
2.dnscrypt-cert.opendns.com
公钥
B735：1140:206 F：225D：3E2B：D822：D7FD：691E：A1C3：3CC8：D666：8D0C：BE04：BFAB：CA43：FB79

CloudNS（没有日志，DNSSEC）
澳大利亚堪培拉
服务器地址
113.20.6.2:443或gc2tzw6lbmeagrp3.onion：443
提供者名称
2.dnscrypt-cert.cloudns.com.au
公钥
1971:7 C1A：C550：6C09：F09B：ACB1：1AF7：C349：6425:2676:247 F：B738：1C5A：243A：C1CC：89F4

澳大利亚悉尼
服务器地址
113.20.8.17:443或l65q62lf7wnfme7m.onion：443
提供者名称
2.dnscrypt-CERT-2.cloudns.com.au
公钥
67A4：323E：581F：79B9：BC54：825F：54FE：1025:8地下四层：37EB：0D07：0BCE：4010:6195：D94F：E330

OpenNIC（无日志）
日本
服务器地址
106.186.17.181:2053
提供者名称
2.dnscrypt-cert.ns2.jp.dns.opennic.glue
公钥
8768：C3DB：F70A：FBC6：3B64：8630:8167:2 FD4：EE6F：E175：ECFD：46C9：22FC：7674：A1AC：2E2A

联合王国
NovaKing（NS8）
服务器地址
185.19.104.45:443
提供者名称
2.dnscrypt-cert.ns8.uk.dns.opennic.glue
公钥
A17C：06FC：BA21：F2AC：F4CD：9374:016答：684F：4F56：564A：EB30：A422：3D9D：1580：A461：B6A6

NovaKing（NS9）
服务器地址
185.19.105.6:443
提供者名称
2.dnscrypt-cert.ns9.uk.dns.opennic.glue
公钥
E864：80D9：东方宝鼎：9DB4：58EA：8063:292 F：EC41：9126:8394：BC44：的Fab8：4B6E：B104：8C3B：E0B4

NovaKing（NS10）
服务器地址
185.19.105.14:443
提供者名称
2.dnscrypt-cert.ns10.uk.dns.opennic.glue
公钥
B1AB：7025:1119:9 AEE：E42E：1B12：F2EF：12D4：53D9：CD92：E07B：9AF4：4794：F6EB：E5A4：F725

美国
服务器地址
173.230.156.28:443
提供者名称
2.dnscrypt-cert.ns17.ca.us.dns.opennic.glue
公钥
2342:215 C：409A：85A5：FB63：2A3B：42CD：5089:6 BA8：551A：8BDC：2654：CF57：804F：B1B2：5019

服务器地址
[2600:3 C01 :: F03C：91FF：fe6e：1f6b]：443
提供者名称
2.dnscrypt-cert.ns18.ca.us.dns.opennic.glue
公钥
689B：DAF2：6A9F：DB2D：42B4：AA15：1825:89 E8：6FAE：0C2C：522A：D0AA：DD2B：80B4：8D61：0A43

DNSCrypt.eu（没有日志，DNSSEC）
荷兰
服务器地址
176.56.237.171:443或[2A00：D880：3:1 :: a6c1：2e89]：443
提供者名称
2.dnscrypt-cert.resolver1.dnscrypt.eu
公钥
67C0：0F2C：21C5：5481:45 DD：7CB4：6A27：1AF2：EB96：9931:40 A3：09B6：2B8D：1653:1185:9 C66

丹麦
服务器地址
77.66.84.233:443或[2001:1448:243 :: DC2]：443
提供者名称
2.dnscrypt-cert.resolver2.dnscrypt.eu
公钥
3748:5585：E3B9：D088：FD25：AD36：B037：01F5：520C：D648：9E9A：DD52：1457:4955:9 F0A：9955
Soltysiak.com（没有日志，DNSSEC）

波兰波兹南
服务器地址
178.216.201.222:2053
提供者名称
2.dnscrypt-cert.soltysiak.com
公钥
25C4：E188：2915:4697:8 F9C：2BBD：B6A7：AFA4：01ED：A051：0508:5 D53：03E7：1928：C066：8F21
