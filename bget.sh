##
# Uploaded
#
function bget() {
	url=$1
	fileRegEx='[^/]*?$'
	regex='<form method="post" action="\K([^"]*)'
	cookie='cookie.txt'
	[[ $url =~ $fileRegEx ]]
	fileName=$BASH_REMATCH
	ulLoginUrl='http://uploaded.net/io/login'

	# Get Cookie
	if [ ! -e "$cookie" ]
	then
		# TODO store credentials
		# TODO Keep cookie as long as it is valid
		echo username:
		read username

		echo password:
		stty_orig=`stty -g` # save original terminal setting.
		stty -echo          # turn-off echoing.
		read password         # read the password
		stty $stty_orig

		wget --quiet --save-cookies=$cookie --post-data="id=$username&pw=$password" -O /dev/null $ulLoginUrl
		# check if cookie is valid
		echo 'got cookie'
	fi

	# Download html, extract file url, download file
	if [ ! -e $fileName ]
	then
		wget --quiet --content-disposition --load-cookies=$cookie $url
		link=$(grep -oP "$regex" $fileName)
		rm $fileName
		wget --content-disposition --load-cookies=c.txt $link
	fi

	rm $cookie
}
