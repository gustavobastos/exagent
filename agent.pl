#!/usr/bin/perl

use NetSNMP::agent (':all');
use NetSNMP::ASN qw(ASN_OCTET_STR ASN_INTEGER);


my $filename = 'data.txt';
my $integer_value;





my $agent = new NetSNMP::agent(
      # makes the agent read a my_agent_name.conf file
      'Name' => "agent",
      'AgentX' => 1
       );


$agent->register("agent", ".1.3.6.1.4.1.54321",
                 \&my_handler);



while (1) {
	open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Não foi possível abrir o arquivo '$filename' $!";
 
	$integer_value = <$fh>;
	close $fh;
	
	$agent->agent_check_and_process(1);
	}
	
$agent->shutdown();
exit 0;


sub my_handler {
  my ($handler, $registration_info, $request_info, $requests) = @_;
  my $request;
  
for($request = $requests; $request; $request = $request->next()) {
    my $oid = $request->getOID();
    if ($request_info->getMode() == MODE_GET) {
      if ($oid == new NetSNMP::OID(".1.3.6.1.4.1.54321.0")) {     
		$request->setValue(ASN_INTEGER, $integer_value);
      }

    } 
  }
return;
}



