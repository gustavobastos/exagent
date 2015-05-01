#!/usr/bin/perl

use NetSNMP::agent (':all');
use NetSNMP::ASN qw(ASN_OCTET_STR ASN_INTEGER);
use Time::Piece;
use DBI;


my $driver = "mysql"; 
my $database = "SNMP";
my $dsn = "DBI:$driver:database=$database";
my $userid = "root";
my $password = "virtual";
my $creation_time;
my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;
my $source_eid;
my $bundle_length;
my $bundle_id;



my $integer_value;
my $data;


my $agent = new NetSNMP::agent(
      # makes the agent read a my_agent_name.conf file
      'Name' => "dtn2",
      'AgentX' => 1
       );


$agent->register("dtn2", ".1.3.6.1.4.1.54321",
                 \&my_handler);

while(1) {
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
      		if ($oid == new NetSNMP::OID(".1.3.6.1.4.1.54321.0.0")) {     
		
			my @resultado;			
			my $sth = $dbh->prepare("SELECT `creation_time` FROM `bundles_aux`");
			$creation_time = "vazio";			
			$sth->execute() or die $DBI::errstr;
			while (my @row = $sth->fetchrow_array()) {
   			($creation_time ) = @row[0]; 			
			push(@resultado,$creation_time);			
			}
			$creation_time = $resultado[0];		
			$request->setValue(ASN_OCTET_STR, $creation_time);
     	 	}
    
	
    	
		elsif ($oid == new NetSNMP::OID(".1.3.6.1.4.1.54321.0.1")) {     
			
			my $sth = $dbh->prepare("SELECT `source_eid` FROM `bundles_aux`");
			$source_eid = "vazio";			
			$sth->execute() or die $DBI::errstr;
			while (my @row = $sth->fetchrow_array()) {
   			($source_eid ) = @row[0]; 			
			push(@resultado,$source_eid);			
			}
			$source_eid = $resultado[0];		
			$request->setValue(ASN_OCTET_STR, $source_eid);
 
						
			
		}		
			
    
		elsif ($oid == new NetSNMP::OID(".1.3.6.1.4.1.54321.0.2")) {     
			my @resultado;			
			my $sth = $dbh->prepare("SELECT `bundle_length` FROM `bundles_aux`");
			$sth->execute() or die $DBI::errstr;
			$bundle_length = "vazio";			
			while (my @row = $sth->fetchrow_array()) {
   			($bundle_length ) = @row[0]; 			
			push(@resultado,$bundle_length);			
			}
			$bundle_length = $resultado[0];		
			$request->setValue(ASN_OCTET_STR, $bundle_length);
						
				
		}		
	
		elsif ($oid == new NetSNMP::OID(".1.3.6.1.4.1.54321.0.3")) {     
			my @resultado;			
			my $sth = $dbh->prepare("SELECT `bundle_id` FROM `bundles_aux` ORDER BY `bundles_aux`.`the_key` ASC");
			$sth->execute() or die $DBI::errstr;
			$bundle_id = "vazio";			
			while (my @row = $sth->fetchrow_array()) {
   			($bundle_id ) = @row[0]; 			
			push(@resultado,$bundle_id);			
			}
			$bundle_id = $resultado[0];		
			$request->setValue(ASN_OCTET_STR, $bundle_id);
		}
}
    

  


	
  }
return;
}












