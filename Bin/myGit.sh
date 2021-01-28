#!/bin/bash

# git init
# git add .
# git commit -a -m "information"
# git push -u origin master 

demand(){
	git status
	echo "What do you want to do using the GIT?"
	echo "1.Initializing repository"
	echo "2.Add files"
	echo "3.Clone repository"
	read -p "Please input the index" index
}



AddFiles(){
	if [ $index == '2']
			read -p "Please input the commit" commit
			git add .
			git commit -m ${commit}
			git push -u origin master
	fi
}

InitRep(){
	if [ $index == '1' ]
			git init
	fi
}

cd ..
read -p "need to initialize? [Y/n]" option
if [ ${option} == "Y" -o ${option} == "y" ]
then
	read -p "Please input GIT's email:  " email
	read -p "Please input GIT's name:  " name
	git config --global user.email ${email}
	git config --global user.name ${name}

	git config --global credential.helper store
fi

git add .
git status

read -p "need to upload? [Y/n]" option
if [ ${option} == "Y" -o ${option} == "y" ]
then
	read -p "Please inpute this version information:" information
	git commit -m "${information}"
	git push -u origin master
fi
#!/bin/bash

read -p "please input version's information:" infor
read -p "please input repository's name:" rep_name
read -p "Is GIT the first time:[Y/n]" option
temp=$(cat ~/.mAccount/account|grep git -A 3|grep name)
name=${temp#*=}

temp=$(cat ~/.mAccount/account |grep git -A 3|grep password)
password=${temp#*=}
if [ $option == "Y" -o $option == "y" ]
then
	git init
fi
git add .
git commit -m "$infor"
if [ $option == "Y" -o $option == "y" ]
then
	git remote add origin https://github.com/${name}/${rep_name}
fi

/usr/bin/expect <<EOF
spawn git push -u origin master 
expect "Username" 
send "${name}\r"
expect "Password" 
send "${password}\r"
expect eof
EOF
