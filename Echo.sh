# Echo printing utility

# README
# Installation: Run `source Echo.sh "PREFIX"`
# Use command `Echo [FLAGS] MSG` instead of `echo [FLAGS] MSG` to print out your
# PREFIX on every line
# Overwrite prefix with `EchoPrefix=PREFIX` to change prefix
# Inside your print messages, insert `$(EchoColor COLOR)` to change color
# By default, `$(EchoColor)` will reset text color to default

# Boolean class
True=0
False=1
Boolean() {
   return $1
}

EchoPrefix="Echo"
if [[ "$@" != "" ]]; then
   EchoPrefix="$@"
fi
EchoPrefixCurrent="$EchoPrefix"
EchoColor() {
   ColorCode="0m"
   case $1 in
      Black)
         ColorCode="0;30m"
         ;;
      Red)
         ColorCode="0;31m"
         ;;
      Green)
         ColorCode="0;32m"
         ;;
      Orange)
         ColorCode="0;33m"
         ;;
      Blue)
         ColorCode="0;34m"
         ;;
      Purple)
         ColorCode="0;35m"
         ;;
      Cyan)
         ColorCode="0;36m"
         ;;
      LightGray)
         ColorCode="0;37m"
         ;;
      DarkGray)
         ColorCode="1;30m"
         ;;
      LightRed)
         ColorCode="1;31m"
         ;;
      LightGreen)
         ColorCode="1;32m"
         ;;
      Yellow)
         ColorCode="1;33m"
         ;;
      LightBlue)
         ColorCode="1;34m"
         ;;
      LightPurple)
         ColorCode="1;35m"
         ;;
      LightCyan)
         ColorCode="1;36m"
         ;;
      White)
         ColorCode="1;37m"
         ;;
   esac
   echo -e "\033[0;$ColorCode"
}
Echo() {
   EchoHasFlags=$True
   EchoFlags=""
   while Boolean $EchoHasFlags; do
      if [[ $1 == "-n" || $1 == "-e" || $1 == "-E" ]]; then
         EchoFlags+="$1 "
         shift
      else
         EchoHasFlags=$False
      fi
   done
   if [[ "$EchoPrefixCurrent" != "" ]]; then
      EchoPrefixCurrent="$EchoPrefix"
   fi
   echo $EchoFlags "$EchoPrefixCurrent $@"
   if echo "${EchoFlags//-/\-}" | grep -q "\-n"; then
      EchoPrefixCurrent=""
   else
      EchoPrefixCurrent="$EchoPrefix"
   fi
}
Read() {
   read $@
   EchoPrefixCurrent="$EchoPrefix"
}
