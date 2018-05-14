describe package('curl') do
	it { should be_installed }
end

describe inetd_conf do
	its("telnet") { should eq nil }
end

