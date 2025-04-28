Task 2: Scenario

Our internal web dashboard (internal.example.com) became unreachable. Users were getting "host not found" errors even though the web service itself was running.
My task was to troubleshoot, verify, and restore DNS and network connectivity to the internal service.
---------------------------------------------
1. Verified DNS Resolution

I checked the DNS resolution using the system's default /etc/resolv.conf.

Then I compared it against Google's public DNS (8.8.8.8) to isolate whether the problem was local or external.



2. Diagnosed Service Reachability

I tried resolving and pinging internal.example.com.

I used curl, telnet, and nc to check if the web server was reachable on ports 80 and 443.



3. Identified Possible Causes

DNS server misconfiguration or downtime

Incorrect /etc/resolv.conf settings

Firewall blocking DNS traffic

Corrupted DNS cache

Service running but not properly listening on network interfaces

Routing issues on the network



4. Applied Fixes

Updated /etc/resolv.conf to point to a working DNS server.

Restarted the DNS client service.

Flushed the DNS cache to clear old/broken entries.

Verified firewall settings to ensure DNS (port 53) was allowed.



5. Confirmed the Root Cause

After updating DNS settings and flushing the cache, I was able to successfully resolve and connect to internal.example.com.

The issue was related to the local DNS resolver configuration.



6. Commands Used



# Check DNS resolution
dig internal.example.com
dig @8.8.8.8 internal.example.com

# Check web service reachability
nc -zv internal.example.com 80
curl -I http://internal.example.com

# Fix DNS settings
sudo nano /etc/resolv.conf

# Restart DNS services
sudo systemctl restart systemd-resolved

# Flush DNS cache
sudo systemd-resolve --flush-caches
