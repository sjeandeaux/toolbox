packages = %w(
  sudo
  bash-completion
  iptables
  git
  tar
  apt-transport-https
  curl
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


