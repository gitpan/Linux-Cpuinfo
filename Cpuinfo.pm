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

=over 4

=cut

use 5.00503;

use strict;

use Carp;

use vars qw(
             $VERSION
             $AUTOLOAD
           );

($VERSION) = q$Revision: 1.1 $ =~ /([\d.]+)/;

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
   
   if ( -e $file and -r $file )
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

=head1 COPYRIGHT AND LICENSE

See the README file in the Distribution Kit

=head1 AUTHOR

Jonathan Stowe, E<lt>gellyfish@gellyfish.comE<gt>

=head1 SEE ALSO

L<perl>.

=cut
