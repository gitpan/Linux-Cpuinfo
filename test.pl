use Test;
BEGIN { plan tests => 12 };
use Linux::Cpuinfo;
ok(1); 

my $cpuinfo;
eval
{
   $cpuinfo = Linux::Cpuinfo->cpuinfo();
   ok(2);
};
if ($@)
{
  ok(0);
}

# Test old interface.

eval
{
   my $bog = $cpuinfo->bogomips();
   ok(3);
};
if ($@)
{
  ok(0);
}
eval
{
  $cpuinfo = Linux::Cpuinfo->new('proc/cpuinfo.x86_smp');
  ok(4);
};
if ( $@)
{
  ok(0);
}
eval
{
  my $num_cpus = $cpuinfo->num_cpus();
  ok(5);
  
  if ( $num_cpus != 2 )
  {
    print $num_cpus,"\n";
    ok(0);
  }
  else
  {
    ok(6);
  }
};
if ( $@ )
{
  ok(0);
  ok(0);
}

# test the new interface.

my $cpu;

eval
{
 $cpu = $cpuinfo->cpu(0);
  ok(7);
};
if ( $@ )
{
  ok(0);
}
    
eval 
{
  my $chip = $cpu->model_name();
  ok(8);

  if ( $chip ne 'Pentium Pro' )
  {
    ok(0);
  }
  else
  {
    ok(9);
  }
};
if ($@ )
{
  ok(0);
  ok(0);
}

eval
{
   foreach $cpu ( $cpuinfo->cpus() )
   {
     my $bog = $cpu->bogomips();
   }
   ok(10);
};
if ( $@ )
{
  ok(0);
}

# Test the new interface to the constructor

eval
{
   $cpuinfo = Linux::Cpuinfo->cpuinfo({NoFatal => 1});
   ok(11);
};

if ( $@ )
{
   ok(0);
}

eval
{
   $cpuinfo->fofoo() && die ;
   ok(12);   
};
if ( $@ )
{
  ok(0);
}
