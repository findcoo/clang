#Develop with vim!

1. Purpose
	* Develop C, CPP with vim
2. Features
	* vim plugins installed
	* YouCompleteMe installed( clang completer )
3. How to Use
	* connection
		* 'ssh <ip> -p <port>'
	* mount & create container
		* 'docker run -d -v <host dir>:/home/User/src> -p <host port:22> image_name'
	* in the container
		* configure '/src/.ycm_extra_conf.py' for yor develop environment
