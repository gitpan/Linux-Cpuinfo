#******************************************************************************
#*           
#*                             GELLYFISH SOFTWARE           
#*                                                       
#*
#******************************************************************************
#*
#*          PROGRAM      :   Linux::Cpuinfo
#*
#*          AUTHOR       :   JNS
#*
#*          DESCRIPTION  :   Object Oriented interface to /proc/cpuinfo
#*
#*****************************************************************************
#*
#*          $Log: Cpuinfo.pm,v $
#*          Revision 1.2  2001/06/17 21:28:26  gellyfish
#*          Ooh forgot the documentation
#*
#*          Revision 1.1  2001/06/17 12:40:16  gellyfish
#*          Checked into CVS for first release
#*
#*
#*
#*****************************************************************************/ 

package Linux::Cpuinfo;

=head1 NAME

Linux::Cpuinfo - Object Oriented Interface to /proc/cpuinfo

=head1 SYNOPSIS

  use Linux::Cpuinfo;

  my $cpu = Linux::Cpuinfo->new();

  print $cpu->model_name();

=head1 DESCRIPTION

On Linux systems various information about the CPU in the computer can
be gleaned from C</proc/cpuinfo>.  This module provides an object oriented
interface to that information for relatively simple use in Perl programs.

=head2 METHODS

It is entirely probable that all of the methods will be different on other
processors than an x86 - I would hope for feedback from users of other
processors to make this complete.

=over 4

=cut

use 5.00503;

use strict;

use Carp;

use vars qw(
             $VERSION
             $AUTOLOAD
           );

($VERSION) = q$Revision: 1.2 $ =~ /([\d.]+)/;

=item cpuinfo

Returns a blessed object suitable for calling the rest of the methods on or
a false value if for some reason C</proc/cpuinfo> cant be opened.  The single
argument can be an alternative file that provides identical information.

=cut

sub cpuinfo
{
   my ( $proto, $file ) = @_;

   my $class = ref($proto) || $proto;

   my $self;

   $file ||= '/proc/cpuinfo';
   
   if ( -e $file  )
   {
    
      if ( open(CPUINFO,$file ) )
      {
         $self = {};

         while(<CPUINFO>)
         {
            chomp;

            my ( $attribute, $value ) = split /\s*:\s*/;

            $attribute =~ s/\s+/_/;

            if ( $value =~ /^(no|yes)$/ )
            {
               $value = $value eq 'yes' ? 1 : 0;
            }
            
            if ( $attribute eq 'flags' )
            {
               @{$self->{flags}} = split / /, $value;
            }
            else
            {
               $self->{$attribute} = $value;
            }
         }

         bless $self, $class;
      }
   }

   return $self;
}

# just in case anyone is a lame as me :)

*new = \&cpuinfo;

=item processor	

As far as I know this is the index of the processor this information is for
this will be zero for a single processor system. Someone might want to tell
me what it is for multiple CPUs

=item vendor_id	

This is a vendor defined string such as 'GenuineIntel'

=item cpu_family	

This should return an integer that will indicate the 'family' of the 
processor - This is for instance '6' for a Pentium III

=item model		

An integer that is probably vendor dependent that indicates their version 
of the above cpu_family

=item model_name	

A string such as 'Pentium III (Coppermine)'.

=item stepping	

I'm lead to believe this is a version increment used by intel.

=item cpu_MHz		

I guess this is self explanatory - it might however be different to what
it says on the box.

=item cache_size	

The cache size for this processor - it might well have the units appended
( such as 'KB' )

=item fdiv_bug	

True if this bug is present in the processor.

=item hlt_bug		

True if this bug is present in the processor.

=item sep_bug		

True if this bug is present in the processor.

=item f00f_bug	

True if this bug is present in the processor.

=item coma_bug	

True if this bug is present in the processor.

=item fpu		

True if the CPU has a floating point unit.

=item fpu_exception	

True if the floating point unit can throw an exception.

=item cpuid_level	

I'm not sure what this is.

=item wp		

Or this.

=item flags		

This is the set of flags that the CPU supports - this is returned as an
array reference.

=item bogomips	

A system constant calculated when the kernel is booted - it is a measure
of the CPU's performance.

=cut


sub AUTOLOAD
{

  my ( $self ) = @_;

  my ( $method ) = $AUTOLOAD =~ /.*::(.+?)$/;

  if ( exists $self->{$method} )
  {
    no strict 'refs';

    *{$AUTOLOAD} = sub {
                         my ( $self ) = @_;
                         return $self->{$method};
                       };

    goto &{$AUTOLOAD};

  }
  else
  {
    croak sprintf(q(Can't locate object method "%s" via package "%s"),
                  $method,
                  ref($self)); 

  }
}

1;
__END__
=head2 EXPORT

None by default.

=head1 BUGS

The enormous bug in this is that I didnt realize when I made this that
the contents of C</proc/cpuinfo > are different for different processors.

I really would be indebted if Linux users from other than x86 processors
would help me document this properly.

=head1 COPYRIGHT AND LICENSE

See the README file in the Distribution Kit

=head1 AUTHOR

Jonathan Stowe, E<lt>gellyfish@gellyfish.comE<gt>

=head1 SEE ALSO

L<perl>.

=cut
