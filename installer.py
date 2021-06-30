from flask import Flask, render_template, request, send_file, redirect, url_for

import os
from time import sleep

installer = Flask(__name__)

@installer.route('/')
def home():
    return render_template('home.html')

@installer.route('/aws', methods=['GET', 'POST'])
def aws():
    if request.method == 'POST':
        args = request.form
        awsfile = request.files['file']
        ostype = args['ostype']
        vmtype = args['vmtype']
        awsacc = args['accesskey']
        awssec = args['secretkey']
        awsregion = args['region']
        disk_size = args['disksize']
        ssl = args['ssl']
        domainname = args.get("domainname") if args.get("domainname") != "" else "http"
        sslmail = args.get("sslmail") if args.get("sslmail") != "" else "http"
        rabbit_pass = args.get("rabbit_pass") if args.get("rabbit_pass") != "" else "password"
        carrier_path = args.get("carrier_path") if args.get("carrier_path") != "" else "/opt"
        redis_pass = args.get("redis_pass") if args.get("redis_pass") != "" else "password"
        influx_pass = args.get("influx_pass") if args.get("influx_pass") != "" else "password"
        influx_user = args.get("influx_user") if args.get("influx_user") != "" else "admin"
        awsfile.save(os.path.join('/installer/aws_install', awsfile.filename))
        os.system('sed -i "s#76#120#g" /installer/templates/status.html')
        os.system(f"bash /installer/aws_install/install.sh {vmtype} {ostype} {awsacc} {awssec} {awsregion} {carrier_path} {redis_pass} {influx_pass} {influx_user} {disk_size} {ssl} {domainname} {sslmail} {rabbit_pass} &")
        return redirect(url_for('status'))
    else:
        return render_template('aws.html')


@installer.route('/gcp', methods=['GET', 'POST'])
def gcp():
    if request.method == 'POST':
        args = request.form
        gcpfile = request.files['file']
        ostype = args['ostype']
        region = args['region']
        vmtype = args['vmtype']
        disk_size = args['disksize']
        ssl = args['ssl']
        domainname = args.get("domainname") if args.get("domainname") != "" else "http"
        sslmail = args.get("sslmail") if args.get("sslmail") != "" else "http"
        rabbit_pass = args.get("rabbit_pass") if args.get("rabbit_pass") != "" else "password"
        carrier_path = args.get("carrier_path") if args.get("carrier_path") != "" else "/opt"
        redis_pass = args.get("redis_pass") if args.get("redis_pass") != "" else "password"
        influx_pass = args.get("influx_pass") if args.get("influx_pass") != "" else "password"
        influx_user = args.get("influx_user") if args.get("influx_user") != "" else "admin"
        gcpaccname = request.form['gcpaccname']
        gcpfile.save(os.path.join('/installer/gcp_install', "credentials.json"))
        os.system('sed -i "s#76#120#g" /installer/templates/status.html')
        os.system(f"bash /installer/gcp_install/install.sh {vmtype} {ostype} {gcpaccname} {region} {carrier_path} {redis_pass} {influx_pass} {influx_user} {disk_size} {ssl} {domainname} {sslmail} {rabbit_pass} &")
        return redirect(url_for('status'))
    else:
        return render_template('gcp.html')

@installer.route('/azure', methods=['GET', 'POST'])
def azure():
    if request.method == 'POST':
        args = request.form
        location = args['region']
        vmtype = args['vmtype']
        disk_size = args['disksize']
        ostype = args['ostype']
        ssl = args['ssl']
        domainname = args.get("domainname") if args.get("domainname") != "" else "http"
        sslmail = args.get("sslmail") if args.get("sslmail") != "" else "http"
        rabbit_pass = args.get("rabbit_pass") if args.get("rabbit_pass") != "" else "password"
        carrier_path = args.get("carrier_path") if args.get("carrier_path") != "" else "/opt"
        redis_pass = args.get("redis_pass") if args.get("redis_pass") != "" else "password"
        influx_pass = args.get("influx_pass") if args.get("influx_pass") != "" else "password"
        influx_user = args.get("influx_user") if args.get("influx_user") != "" else "admin"
        os.system("ssh-keygen -b 4096 -t rsa -f /installer/azure_install/id_rsa -q -N ''")
        os.system('sed -i "s#76#120#g" /installer/templates/status.html')
        os.system(f"bash /installer/azure_install/install.sh {location} {vmtype} {ostype} {carrier_path} {redis_pass} {influx_pass} {influx_user} {ssl} {domainname} {sslmail} {rabbit_pass} {disk_size} &")
        return redirect(url_for('status'))
    else:
        os.system('nohup az login & sleep 5 && sed -i "s#MYCODE#`cat nohup.out`#g" /installer/templates/azure.html')
        return render_template('azure.html')


@installer.route('/ssh', methods=['GET', 'POST'])
def ssh():
    if request.method == 'POST':
        args = request.form
        sshipaddr = args['ipaddr']
        sshuser = args['username']
        sshrsa = args['file']
        ssl = args['ssl']
        domainname = args.get("domainname") if args.get("domainname") != "" else "http"
        sslmail = args.get("sslmail") if args.get("sslmail") != "" else "http"
        rabbit_pass = args.get("rabbit_pass") if args.get("rabbit_pass") != "" else "password"
        carrier_path = args.get("carrier_path") if args.get("carrier_path") != "" else "/opt"
        redis_pass = args.get("redis_pass") if args.get("redis_pass") != "" else "password"
        influx_pass = args.get("influx_pass") if args.get("influx_pass") != "" else "password"
        influx_user = args.get("influx_user") if args.get("influx_user") != "" else "admin"
        sshrsa.save(os.path.join('/installer/ssh_install', "id_rsa"))
        os.system(f"bash /installer/ssh_install/install.sh {sshipaddr} {sshuser} {carrier_path} {redis_pass} {influx_pass} {influx_user} {ssl} {domainname} {sslmail} {rabbit_pass} &")
        return redirect(url_for('status'))
    else:
        return render_template('ssh.html')


@installer.route('/local', methods=['GET', 'POST'])
def self():
    if request.method == 'POST':
        args = request.form
        ssl = args["ssl"]
        ipordns = args["public_ip"].replace("http://", "").replace("https://", "")
        carrier_path = args.get("carrier_path") if args.get("carrier_path") != "" else "/opt"
        redis_pass = args.get("redis_pass") if args.get("redis_pass") != "" else "password"
        influx_pass = args.get("influx_pass") if args.get("influx_pass") != "" else "password"
        influx_user = args.get("influx_user") if args.get("influx_user") != "" else "admin"
        sslmail = args.get("sslmail") if args.get("sslmail") != "" else "dev"
        rabbit_pass = args.get("rabbit_pass") if args.get("rabbit_pass") != "" else "password"
        os.system(f"bash local_install/install.sh {ssl} {ipordns} {carrier_path} {redis_pass} {influx_pass} {influx_user} {sslmail} {rabbit_pass} &")
        return redirect(url_for('status'))
    else:
        return render_template('local.html')


@installer.route('/localdefault')
def localdef():
    os.system("bash local_install/install.sh " + "def &")
    return redirect(url_for('status'))


@installer.route('/status')
def status():
    return render_template('status.html')

@installer.route('/terraformdestroy')
def terraformdestroy():
    os.system("bash ./destroyinfra.sh &")
    return redirect(url_for('status'))

if __name__ == "__main__":
    installer.run(host="0.0.0.0", port="1337", debug=True)
