use Test;
BEGIN { plan tests => 3 };
use Linux::Cpuinfo;
ok(1); 

my $cpu;
eval
{
   $cpu = Linux::Cpuinfo->cpuinfo();
   ok(2);
};
if ($@)
{
  ok(0);
}
eval
{
   my $bog = $cpu->bogomips();
   ok(3);
};
if ($@)
{
  ok(0);
}
