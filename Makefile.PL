use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Linux::Cpuinfo',
    'VERSION_FROM'	=> 'Cpuinfo.pm', 
    'PREREQ_PM'		=> {}, 
    ($] >= 5.005 ?   
      (ABSTRACT_FROM => 'Cpuinfo.pm',
       AUTHOR     => 'Jonathan Stowe <gellyfish@gellyfish.com>') : ()),
);
