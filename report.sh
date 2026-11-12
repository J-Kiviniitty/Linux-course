#!/usr/bin/env bash

# Collect system information

GENERATED_AT=$(date)

UPTIME_TEXT=$(uptime -p)

DISK_USAGE=$(df -P / | awk 'NR == 2 {print $5}')

DISK_USAGE_NUMBER=$(echo "$DISK_USAGE" | tr -d '%')

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')

MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')

GITHUB_URL="https://github.com/J-Kiviniitty/Linux-course"

# Function for disk status

get_disk_status() {

    if [ "$DISK_USAGE_NUMBER" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DISK_STATUS=$(get_disk_status)

# Generate report

cat > /var/www/html/viikko3/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Week 3 – Server Status Report</title>
    <style>
        body {
            font-family: system-ui, sans-serif;
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
            line-height: 1.6;
            background: #f1f5f9;
            color: #172033;
        }

        h1, h2 {
            color: #173b65;
        }

        section {
            margin: 24px 0;
            padding: 24px;
            background: white;
            border-radius: 12px;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid #cbd5e1;
            padding: 12px;
            text-align: left;
        }

        th {
            background: #dbeafe;
        }

        code {
            background: #e2e8f0;
            padding: 2px 5px;
            border-radius: 4px;
            overflow-wrap: anywhere;
        }

        a {
            color: #1746a2;
        }

        .note {
            color: #475569;
        }
    </style>
</head>
<body>
    <header>
        <h1>Server Status Report</h1>
        <p>Week 3: Linux command line and Bash scripting</p>
        <p>This is automatically generated report on my Ubuntu -virtual server using Bash-script and Nginx.</p>
    </header>

    <section>
        <h2>Current server status</h2>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Information</th>
                        <th scope="col">Value</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row">Report generated</th>
                        <td>$GENERATED_AT</td>
                    </tr>
                    <tr>
                        <th scope="row">Server uptime</th>
                        <td>$UPTIME_TEXT</td>
                    </tr>
                    <tr>
                        <th scope="row">Root filesystem disk usage</th>
                        <td>$DISK_USAGE</td>
                    </tr>
                    <tr>
                        <th scope="row">Disk space status</th>
                        <td>$DISK_STATUS</td>
                    </tr>
                    <tr>
                        <th scope="row">Total RAM</th>
                        <td>$MEM_TOTAL MiB</td>
                    </tr>
                    <tr>
                        <th scope="row">Available RAM</th>
                        <td>$MEM_AVAILABLE MiB</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <p>
            Disk space status is <strong>OK</strong> below 80% usage
            and <strong>WARNING</strong> at 80% or above.
        </p>

        <p class="note">
            Bash generates this report once per minute.
            Wait approximately 1–2 minutes and reload the page
            to see a new generation time.
        </p>
    </section>

    <section>
        <h2>Commands used</h2>
        <ul>
            <li>
                <code>date</code>:
                displays the current date, time and time zone
                using the format specified in the script.
            </li>
            <li>
                <code>uptime -p</code>:
                displays how long the server has been running.
            </li>
            <li>
                <code>df -P / | awk 'NR == 2 {print &#36;5}'</code>:
                passes filesystem information to awk, which extracts
                the usage percentage from the second row.
            </li>
            <li>
                <code>free -m</code>:
                displays memory information in mebibytes (MiB).
            </li>
        </ul>
    </section>

    <section>
        <h2>How the script works</h2>
        <p>
            The script collects server information using Linux commands
            and stores the results in Bash variables through command
            substitution. A function uses an if statement to determine
            the disk space status.
        </p>
        <p>
            The script generates a temporary HTML file and then moves
            the completed file into place as index.html.
            Nginx serves this file at /viikko3/.
        </p>
        <p>
            The disk status function uses an if statement to determine 
	    whether the root filesystem usage is below 80% (OK) or at least 
	    80% (WARNING). An example of piping used in the script 
	    is: df -P / | awk 'NR == 2 {print $5}' where the output of df is 
	    passed to awk to extract the disk usage percentage.
        </p>
    </section>

    <section>
        <h2>Scheduling</h2>
        <p>
            A systemd timer will be used to run the report generation script once per 
	    minute. The timer starts automatically after reboot and continues generating 
	    updated reports without user interaction.

        </p>
    </section>

    <section>
        <h2>Test results</h2>

        <h3>Syntax check and manual execution</h3>
        <p>
            The command bash -n report.sh was used to validate the script syntax. The command produced 
	    no output, indicating that no syntax errors were found in the script. The script was then executed 
	    manually using ./report.sh. The execution completed successfully and generated the index.html 
	    report file in the /var/www/html/viikko3/ directory. After refreshing the browser, the report page 
	    displayed the current server information correctly, including the generation time, uptime, disk 
	    usage, disk status, and memory information.

        </p>

        <h3>Disk space status tests</h3>
        <p>
             The disk space status was tested with manual input values. When manually inserting disk 
	     usage status of 50% test outcome was OK. When tested with values 80% and 90% the outcome 
	     was WARNING. Therefore the disck space status test was succesful.
        </p>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Test input</th>
                        <th scope="col">Expected status</th>
                        <th scope="col">Actual status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>50%</td>
                        <td>OK</td>
                        <td>OK</td>
                    </tr>
                    <tr>
                        <td>80%</td>
                        <td>WARNING</td>
                        <td>WARNING</td>
                    </tr>
                    <tr>
                        <td>90%</td>
                        <td>WARNING</td>
                        <td>WARNING</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <h3>Automatic updates</h3>
        <p>
            Timestamp generation 1: 15:59:01 
	    and timestamp generation 2: 16:00:03
        </p>

        <h3>Reboot test</h3>
        <p>
            The virtual machine was rebooted successfully. After reboot, the Week 1 page, 
	    Week 2 Flask application (/viikko2/) and Week 3 report page (/viikko3/) were 
	    all accessible. The systemd timer remained active and the report generation 
	    timestamp continued updating automatically every minute.

        </p>
    </section>

    <section>
        <h2>A problem solved or a lesson learned</h2>
        <p>Initially, the script could not write index.html to /var/www/html/viikko3/ 
	   because of Linux file permissions. The issue was resolved by changing the 
	   ownership of the directory using chown. This demonstrated how file ownership 
	   affects web content publishing on Linux servers.
</p>
    </section>

    <footer>
        <p><a href="$GITHUB_URL">View the source code on GitHub</a></p>
    </footer>
</body>
</html>
EOF
