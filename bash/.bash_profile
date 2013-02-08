# ================================================
# Global Vars
# ================================================
export RCPP_HOME=/usr/local/rcpp
export RCPP_BIN=$RCPP_HOME/tools
export SAGE_ROOT=/Applications/Sage.app/Contents/Resources/sage

#=================================================
# Path Modifications
#=================================================
export PATH=/usr/local/bin:$PATH
export PATH=$RCPP_BIN:$PATH

#=================================================
# Alias Changes
#=================================================

# Command Re-Mapping
# ------------------------------------------------
alias ls='gls -1XF --color'
# The 'gls' command is the GNU version.
# -1 Prints entries in one line
# -F classifies entry type by directory, file, symlink by prefix
# -G colorizes


# Command Shortcuts
# ------------------------------------------------
alias js-test-server='java -jar ~/scripts/JsTestDriver-1.3.5.jar --port 9876'
alias js-test='java -jar ~/scripts/JsTestDriver-1.3.5.jar
              --tests all --captureConsole'

# Server Shortcuts
# -----------------------------------------------
alias ssh-cse='ssh -X hutcheso@stdlinux.cse.ohio-state.edu'
alias knuth-away='rdesktop -f knuth.no-ip.org'
alias knuth-home='rdesktop -f 192.168.1.11'
