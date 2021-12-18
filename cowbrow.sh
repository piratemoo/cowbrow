#!/bin/bash
cat cowbrow.txt
echo ""
echo "A small OSINT/dorking script that works in-browser created by piratemoo"
echo "When you choose a target, your browser will open: Close it and the next query starts"
echo "https://www.piratemoo.com @apiratemoo"

BROWSER="firefox"

function osintLookup()
	{
		#Target's website
		tput setaf 6
		echo "opening http/https versions of the target"
		$BROWSER http://$ADDRESS | $BROWSER https://$ADDRESS

		# netcraft, shodan, censys, security headers, threatcrows, zoomeye
		echo "starting basic osint search..."
		tput setaf 7
		echo "opening shodan.io"
		$BROWSER https://www.shodan.io/search?query=$ADDRESS --new tab
		echo "opening censys: please input your search in the field"
		$BROWSER https://www.censys.io/ipv4?q= --new tab
		echo "opening netcraft"
		$BROWSER http://sitereport.netcraft.com/?url=$ADDRESS
		echo "opening security headers"
		$BROWSER https://securityheaders.com/?q=$ADDRESS
		echo "opening threatcrowd"
		$BROWSER https://www.threatcrowd.org/domain.php?domain=$ADDRESS
		echo "opening zoomeye"
		$BROWSER https://www.zoomeye.org/searchResult/bugs?q=$ADDRESS

		# SSL Checks crt.sh, ssl labs, ssl shopper
		tput setaf 6
		echo "starting SSL checks..."
		tput setaf 7
		echo "opening crt.sh"
		$BROWSER https://crt.sh/?q=$ADDRESS
		echo "opening ssl labs"
		$BROWSER https://www.ssllabs.com/ssltest/analyze.html?d=$ADDRESS
		echo "opening ssl shopper"
		$BROWSER https://www.sslshopper.com/ssl-checker.html#hostname=$ADDRESS

		#DNS checks
		tput setaf 6
		echo "starting DNS checks..."
		tput setaf 7
		echo "opening dns dumpster"
		$BROWSER https://dnsdumpster.com
		echo "opening security trails"
		$BROWSER https://securitytrails.com/list/keyword/$ADDRESS
		echo "opening view dns"
		$BROWSER http://viewdns.info/reversewhois/?q=$ADDRESS
		echo "opening wayback machine archive"
		$BROWSER https://web.archive.org/web/*/$ADDRESS
	}

function googleDork()
	{
	   	# inurl check
	     	tput setaf 6
		echo "checking inurl statements..."
		$BROWSER https://www.google.com/search?q=inurl:$DORKLING

       		# login checks
		echo "checking login statements..."
        	$BROWSER https://www.google.com/search?q=site%3A*+$DORKLING
       		$BROWSER https://www.google.com/search?q=site:*.*.+$DORKLING
		$BROWSER https://www.google.com/search?q=site:%3A+$DORKLING+%2Busername%2Bor%2Bpassword%2Bor%2Blogin

		# checking wordpress
		tput setaf 7
		echo "checking wordpress..."
		$BROWSER https://www.google.com/search?q=site:$DORKLING+inurl:wp-+OR+inurl:plugin+OR+i
	}

menu=(
	"osint lookup"
	"dork it!"
        "quit"
     )

select option in "${menu[@]}"
do
	case "$REPLY" in

		1) read -p "enter target address:" ADDRESS
		   echo "Targeting $ADDRESS..."
		   osintLookup ;;

  		2) read -p "what would you like to dork?" DORKLING
          	   echo "Targeting $DORKLING..."
		   googleDork ;;

		3) exit ;;
  esac
done
exit
