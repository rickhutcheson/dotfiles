#=================================================
# Path Modifications
#=================================================
PATH=/usr/local/bin:$PATH

#=================================================
# Alias Changes
#=================================================

# Command Re-Mapping
# ------------------
# -1 Prints entries in one line
# -F classifies entry type by directory, file, symlink by prefix
# -G colorizes
alias ls='gls -1XF --color'

# Command Shortcuts
# -----------------
alias js-test-server='java -jar ~/scripts/JsTestDriver-1.3.5.jar --port 9876'
alias js-test='java -jar ~/scripts/JsTestDriver-1.3.5.jar
              --tests all --captureConsole'

# Server Shortcuts
# ----------------
alias ssh-cse='ssh -X stdlinux.cse.ohio-state.edu'
alias knuth-away='rdesktop -f knuth.no-ip.org'
alias knuth-home='rdesktop -f 192.168.1.11'
