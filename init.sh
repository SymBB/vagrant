#!/usr/bin/env sh
# Do the initial apt-get update
echo "Initial apt-get update..."
apt-get update >/dev/null
apt-get install -y lsb-release >/dev/null
# Load up the release information
DISTRIB_CODENAME=$(lsb_release -c -s)
REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb"
# Install wget if we have to (some older Debian versions)
echo "Installing wget..."
apt-get install -y wget >/dev/null
# Install the PuppetLabs repo
echo "Configuring PuppetLabs repo..."
repo_deb_path=$(mktemp)
wget --output-document="${repo_deb_path}" "${REPO_DEB_URL}" 2>/dev/null
dpkg -i "${repo_deb_path}" >/dev/null
apt-get update >/dev/null
# Install Puppet
echo "Installing Puppet..."
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet >/dev/null
echo "Puppet installed!"
echo "Installing SSH..."
apt-get install openssh-server >/dev/null
echo "SSH installed!"