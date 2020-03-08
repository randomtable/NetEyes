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

![Application](https://raw.githubusercontent.com/randomtable/NetEyes/master/Images/2.png)

- Insert a domain or IP, then click on your favorite script.

You will se result files as "result.xml", "result.nmap" and "result.gnmap" in the application folder.
