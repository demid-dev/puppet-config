# Setting up Puppet Server and Agent on AWS EC2

This guide provides step-by-step instructions for setting up Puppet Server and Agent on an Amazon Web Services (AWS) Elastic Compute Cloud (EC2) instance.

## Step 1: Set up an AWS account

1. Go to the AWS Management Console at https://aws.amazon.com/console/.
2. If you don't already have an AWS account, click "Sign Up" and follow the on-screen instructions to create one.

## Step 2: Launch an EC2 instance

1. Sign in to the AWS Management Console.
2. Navigate to the EC2 Dashboard.
3. Click on "Instances" in the left menu, then click "Launch Instance."
4. Select an Amazon Linux 2 AMI (recommended for Puppet (NOT AMAZON LINUX 2023!!!)).
5. Choose an instance type (e.g., t2.micro), then click "Next: Configure Instance Details."
6. Configure instance details as per your requirements and click "Next: Add Storage."
7. Add storage if needed, then click "Next: Add Tags."
8. Add tags to your instance for better organization, then click "Next: Configure Security Group."
9. Create a new security group, allowing SSH (port 22), HTTP/HTTPS (ports 80 and 443), custom TCP (port 8140) access, then click "Review and Launch."
10. Review your instance settings, then click "Launch."
11. Create or select an existing key pair, then click "Launch Instances."

## Step 3: Install Puppet Server

1. SSH into your EC2 instance.
2. Update the package list with `sudo yum update -y`.
3. Install the Puppet repository with `sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-7.noarch.rpm`.
4. Install Puppet Server with `sudo yum install puppetserver -y`.
5. Configure memory allocation for the Puppet Server by editing the `/etc/sysconfig/puppetserver` file (e.g., by setting `JAVA_ARGS="-Xms512m -Xmx512m"`).
6. Enable and start the Puppet Server service with `sudo systemctl enable puppetserver && sudo systemctl start puppetserver`.

## Step 4: Install Puppet Agent

1. On the client node, install the Puppet repository with `sudo rpm -Uvh https://yum.puppet.com/puppet7-release-el-7.noarch.rpm`.
2. Install Puppet Agent with `sudo yum install puppet-agent -y`.
3. Update the `/etc/puppetlabs/puppet/puppet.conf` file to include the Puppet Server's hostname:
`[main]
server = your-puppet-server-hostname`
4. Enable and start the Puppet Agent service with `sudo systemctl enable puppet && sudo systemctl start puppet`.

## Step 5: Sign the Puppet Agent certificate

1. On the Puppet Server, list pending certificate requests with `sudo /opt/puppetlabs/bin/puppetserver ca list`.
2. Register `puppet` hostname for `127.0.0.1` in `/etc/hosts` file to include the correct mapping
3. Sign the certificate request for the Puppet Agent with `sudo /opt/puppetlabs/bin/puppetserver ca sign --certname your-puppet-agent-hostname`.

## Step 6: Create and apply Puppet manifests

1. On the Puppet Server, create a manifest file (e.g., `/etc/puppetlabs/code/environments/production/manifests/site.pp`) and add your desired configuration (the example for a manifest could be found in rep)
2. On the Puppet Agent, run `sudo /opt/puppetlabs/bin/puppet agent --test` to apply the manifest.

## Step 7: Automate Puppet Agent runs

1. On the Puppet Agent, edit the `/etc/puppetlabs/puppet/puppet.conf` file to configure the agent's run interval. For example, you can set the run interval to 30 minutes by adding the following line to the file:
`runinterval = 30m`
2. Restart the Puppet Agent service with `sudo systemctl restart puppet`.
3. Confirm that the Puppet Agent service is running and enabled with `sudo systemctl status puppet`



