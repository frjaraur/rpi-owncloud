<?php
	$OWNCLOUDCFGFILE='/etc/owncloud/config.php';
	include "$OWNCLOUDCFGFILE";

	$writefile=$OWNCLOUDCFGFILE."tmp";

	if ($CONFIG['trusted_domains']){ unset($CONFIG['trusted_domains']);	 }

	$r_config=var_export($CONFIG,true);
	
	$fp=fopen($writefile,'w');

	fwrite($fp,"<?php\n");
	fwrite($fp,"\n\$CONFIG=");
	fwrite($fp,$r_config);
	fwrite($fp,"\n?>");
	fclose($fp);


?>
