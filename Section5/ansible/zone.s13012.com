$TTL 60
@	IN SOA ns.s13012.com. s13012.std.it-college.ac.jp. (
	2015060301;
	60;
	900;
	3600;
	60)

	IN	NS	ns.s13012.com.
	IN	MX	10	aspmx.l.google.com.
	IN	NS	ns2.s13012.com.
www	IN	A	172.16.43.76
ns	IN	A	172.16.43.76
ns2	IN	A	172.16.44.76


