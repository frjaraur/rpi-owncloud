<?php
	$OWNCLOUDCFGFILE=getenv('OWNCLOUDCFGFILE');
	include "$OWNCLOUDCFGFILE";

	#print_r($CONFIG);
	#print_r($CONFIG[trusted_domains]);
	#print "$CONFIG[overwrite.cli.url]";

	$variables=array_keys($CONFIG);

	#print_r($variables);

	foreach ($CONFIG as $a=>$b){
		#print "\n$a -- $b ";
		if ($a == "overwrite.cli.url"){
			print "\nBINGO!!!";
		}
	}
?>
