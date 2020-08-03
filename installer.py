from flask import Flask, render_template, request, send_file

import os
from subprocess import Popen, PIPE, CalledProcessError

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
        awsfile.save(os.path.join('/installer/aws_install', awsfile.filename))
        test = os.system("bash /installer/aws_install/install.sh " + vmtype + " " + ostype + " " + awsacc + " " + awssec + " " + awsregion)
        return "status here"
    else:
        return render_template('aws.html')

@installer.route('/gcp', methods=['GET', 'POST'])
def gcp():
    if request.method == 'POST':
        gcpfile = request.files['file']
        ostype = request.form['ostype']
        region = request.form['region']
        vmtype = request.form['vmtype']
        gcpaccname = request.form['gcpaccname']
        gcpfile.save(os.path.join('/installer/gcp_install', "credentials.json"))
        test = os.system("bash /installer/gcp_install/install.sh " + vmtype + " " + ostype + " " + gcpaccname + " " + region)
        return "status here"
    else:
        return render_template('gcp.html')


@installer.route('/azure', methods=['GET', 'POST'])
def azure():
    if request.method == 'POST':
        location = request.form['region']
        vmtype = request.form['vmtype']
        ostype = request.form['ostype']
        os.system("ssh-keygen -b 4096 -t rsa -f /installer/azure_install/id_rsa -q -N ''")
        os.system("bash /installer/azure_install/install.sh " + location + " " + vmtype + " " + ostype)
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
        sshrsa.save(os.path.join('/installer/ssh_install', "id_rsa"))
        with open("carrier.log", "r") as f:
            content = f.read()
        os.system("bash /installer/ssh_install/install.sh " + sshipaddr + " " + sshuser)
    else:
        return render_template('ssh.html')


@installer.route('/local')
def self():
    test = os.system("bash local_install/install.sh")
    return test


if __name__ == "__main__":
    installer.run(host="0.0.0.0", port="1337", debug=True)
