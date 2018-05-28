packages = %w(
  sudo
  bash-completion
  iptables
  git
  tar
  apt-transport-https
  curl
  ksh
  python3
  python3-pip
  vim
  unzip
  ssh
  jq
)

packages.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end


describe command('mvn -version') do
  its('exit_status') { should eq 1 } ##java not here
end

describe command('packer -version') do
  its('exit_status') { should eq 0 }
end

describe command('foodcritic --version') do
  its('exit_status') { should eq 0 }
end

describe command('cookstyle --version') do
  its('exit_status') { should eq 0 }
end

describe command('inspec --version') do
  its('exit_status') { should eq 0 }
end

describe command('go version') do
  its('exit_status') { should eq 0 }
end

describe command('docker --version') do
  its('exit_status') { should eq 0 }
end

describe command('aws --version') do
  its('exit_status') { should eq 0 }
end

describe command('docker-compose --version') do
  its('exit_status') { should eq 0 }
end
