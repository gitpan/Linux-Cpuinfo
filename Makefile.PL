use ExtUtils::MakeMaker;

if ( ! -f '/proc/cpuinfo' )
{
   print <<EONOCPUINFO;
****************************************************

You dont appear to have /proc/cpuinfo on your system 
If you have a similar file located elsewhere then this
module may well still work - if you dont however then
its unlikely this module will be very useful to you.

****************************************************
EONOCPUINFO
}

WriteMakefile(
    'NAME'		=> 'Linux::Cpuinfo',
    'VERSION_FROM'	=> 'Cpuinfo.pm', 
    'PREREQ_PM'		=> {}, 
    ($] >= 5.005 ?   
      (ABSTRACT_FROM => 'Cpuinfo.pm',
       AUTHOR     => 'Jonathan Stowe <gellyfish@gellyfish.com>') : ()),
);
