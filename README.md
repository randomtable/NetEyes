# NetEyes
A tool for OWASP Amass and nmap automation

The Release folder contains the tool.

For use the tool, insert domain in the textbox and choose if fire scan with Vulscan or Vulners scripts.

The tool will launch an Amass scan, normalize the result and automatically launch an nmap scan with the chosen script.

# Detailed instructions

#### Please note: The tool will delete the "amass" folder in the %appdata% directory. Please backup your files before start the scan with the tool

- Open the Release folder:

![Release Folder](https://raw.githubusercontent.com/randomtable/NetEyes/master/Images/1.png)

- Run the application:

![Application](https://raw.githubusercontent.com/randomtable/NetEyes/master/Images/4.png)

- Insert a domain or IP, then click on your favorite script.

You will se result files as "result.xml", "result.nmap" and "result.gnmap" in the application folder:

![Result](https://raw.githubusercontent.com/randomtable/NetEyes/master/Images/3.png)

# Uncover threats on your domain or IPs

NetEyes can help you to uncover threats on your network, or simply track visible events from outside.

For achive this, NetEyes scans your IP or Domain with Amass and call an external PHP Platform called "NetWatcher".

NetWatcher will call VirusTotal and calculate results to provide you if there is a IOC (an active and recent visible threat) or not.

To do this, provide a domain/IP and a VirusTotal API.

![VirusTotal](https://raw.githubusercontent.com/randomtable/NetEyes/master/Images/5.png)

NetEyes will create two files, resultrecon.txt (IPs extracted from Amass scan phase) and resultmalware.txt (IOCs extracted by VirusTotal inquiry).

An example of resultmalware.txt:

![Malware](https://raw.githubusercontent.com/randomtable/NetEyes/master/Images/6.png)

As you can see, the last coloumn show you if the hash is an active, recent threat and represent an IOC.
