from flask import Flask, render_template, request, send_file, redirect, url_for

import os

installer = Flask(__name__)

@installer.route('/')
def home():
    return render_template('home.html')

@installer.route('/aws', methods=['GET', 'POST'])
def aws():
    if request.method == 'POST':
        awsfile = request.files['file']
        ostype = request.form['ostype']
        vmtype = request.form['vmtype']
        awsacc = request.form['accesskey']
        awssec = request.form['secretkey']
        awsregion = request.form['region']
        carrier_path = request.form.get("carrier_path", "/opt")
        redis_pass = request.form.get("redis_pass", "password")
        influx_pass = request.form.get("influx_pass", "password")
        awsfile.save(os.path.join('/installer/aws_install', awsfile.filename))
        os.system('sed -i "s#76#120#g" /installer/templates/status.html')
        os.system(f"bash /installer/aws_install/install.sh {vmtype} {ostype} {awsacc} {awssec} {awsregion} {carrier_path} {redis_pass} {influx_pass} {influx_user} &")
        return redirect(url_for('status'))
    else:
        return render_template('aws.html')

@installer.route('/gcp', methods=['GET', 'POST'])
def gcp():
    if request.method == 'POST':
        gcpfile = request.files['file']
        ostype = request.form['ostype']
        region = request.form['region']
        vmtype = request.form['vmtype']
        carrier_path = request.form.get("carrier_path", "/opt")
        redis_pass = request.form.get("redis_pass", "password")
        influx_pass = request.form.get("influx_pass", "password")
        gcpaccname = request.form['gcpaccname']
        gcpfile.save(os.path.join('/installer/gcp_install', "credentials.json"))
        os.system('sed -i "s#76#120#g" /installer/templates/status.html')
        os.system(f"bash /installer/gcp_install/install.sh {vmtype} {ostype} {gcpaccname} {region} {carrier_path} {redis_pass} {influx_pass} {influx_user} &")
        return redirect(url_for('status'))
    else:
        return render_template('gcp.html')


@installer.route('/azure', methods=['GET', 'POST'])
def azure():
    if request.method == 'POST':
        location = request.form['region']
        vmtype = request.form['vmtype']
        ostype = request.form['ostype']
        carrier_path = request.form.get("carrier_path", "/opt")
        redis_pass = request.form.get("redis_pass", "password")
        influx_pass = request.form.get("influx_pass", "password")
        os.system("ssh-keygen -b 4096 -t rsa -f /installer/azure_install/id_rsa -q -N ''")
        os.system('sed -i "s#76#120#g" /installer/templates/status.html')
        os.system(f"bash /installer/azure_install/install.sh {location} {vmtype} {ostype} {carrier_path} {redis_pass} {influx_pass} {influx_user} &")
        return send_file("/installer/azure_install/id_rsa", as_attachment=True)
    else:
        os.system('nohup az login & sleep 2 && sed -i "s#MYCODE#`cat nohup.out`#g" /installer/templates/azure.html')
        return render_template('azure.html')


@installer.route('/ssh', methods=['GET', 'POST'])
def ssh():
    if request.method == 'POST':
        sshipaddr = request.form['ipaddr']
        sshuser = request.form['username']
        sshrsa = request.files['file']
        carrier_path = request.form.get("carrier_path", "/opt")
        redis_pass = request.form.get("redis_pass", "password")
        influx_pass = request.form.get("influx_pass", "password")
        sshrsa.save(os.path.join('/installer/ssh_install', "id_rsa"))
        os.system(f"bash /installer/ssh_install/install.sh {sshipaddr} {sshuser} {carrier_path} {redis_pass} {influx_pass} {influx_user} &")
        return redirect(url_for('status'))
    else:
        return render_template('ssh.html')


@installer.route('/local', methods=['GET', 'POST'])
def self():
    if request.method == 'POST':
        ssl = request.form["ssl"]
        ipordns = request.form["public_ip"].replace("http://", "").replace("https://", "")
        carrier_path = request.form.get("carrier_path", "/opt")
        redis_pass = request.form.get("redis_pass", "password")
        influx_pass = request.form.get("influx_pass", "password")
        influx_user = request.form.get("influx_user", "admin")
        sslmail = request.form['sslmail']
        os.system(f"bash local_install/install.sh {ssl} {ipordns} {carrier_path} {redis_pass} {influx_pass} {influx_user} {sslmail} &")
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


if __name__ == "__main__":
    installer.run(host="0.0.0.0", port="1337", debug=True)
