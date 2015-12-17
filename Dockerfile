FROM ubuntu:15.10

MAINTAINER findcoo <powzxc@gmail.com>

RUN apt-get update && \
	    apt-get -y install build-essential \
	    			vim git curl mercurial wget \
						openssh-server python-dev ctags \
						tmux supervisor cmake \
						llvm sudo libclang-3.7-dev \
						clang
				
RUN mkdir /var/run/sshd && \
	useradd -m User -s /bin/bash && \
	echo 'root:root' | chpasswd && \
	echo 'User:User' | chpasswd && \
	echo 'User 	ALL=(ALL) 	ALL' > /etc/sudoers.d/User && \
	sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
 	sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV HOME /home/User
WORKDIR $HOME

#-- neobundle install
ENV NEOBUNDLE https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh
RUN curl $NEOBUNDLE > install.sh && \
	    sh ./install.sh && \
	    rm ./install.sh

#-- install and setup vim plugins
RUN echo "\"neobundle start" \
	    "\nlet g:neobundle#install_process_timeout=1500" \
	    "\nset runtimepath+=~/.vim/bundle/neobundle.vim/" \
	    "\ncall neobundle#begin(expand('~/.vim/bundle/'))" \
	    "\nNeoBundleFetch 'Shougo/neobundle.vim'" \
	    "\nNeoBundle 'tpope/vim-fugitive'" \
	    "\nNeoBundle 'scrooloose/nerdtree'" \
	    "\nNeoBundle 'ervandew/supertab'" \
	    "\ncall neobundle#end()" \
	    "\nNeoBundleCheck" >> $HOME/.vimrc && \
	echo "\n\n\"supertab setting" \
		"\nlet g:SupperTabDefaultCompletionType = \"context\"" >> $HOME/.vimrc && \
	echo "\n\n\"YCM setting" \
		"\nlet g:ycm_extra_conf_vim_data = []" \
		"\nlet g:ycm_path_to_python_interpreter = ''" \
		"\nlet g:ycm_server_log_level = 'info'" >> $HOME/.vimrc  && \
	echo "\n\n\"vim default setting" \
		"\nset nu" \
		"\nset autochdir" \
		"\nset ts=2" \
		"\nset bs=2" \
		"\nset noexpandtab" \
		"\nset nocompatible" \
		"\nset cindent" \
		"\nset smartindent" \
		"\nsyntax on" \
		"\nfiletype plugin indent on" >> $HOME/.vimrc

WORKDIR $HOME/.vim/bundle	
RUN git clone https://github.com/Valloric/YouCompleteMe
WORKDIR $HOME/.vim/bundle/YouCompleteMe
RUN git submodule update --init --recursive && \
	./install.py --clang-completer --system-libclang
	
WORKDIR $HOME
RUN mkdir src && chown -R User:User $HOME && \
	cp $HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py $HOME/src/

VOLUME $HOME/src

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
