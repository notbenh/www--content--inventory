package WWW::Content::Inventory::Site;
use Moose;

has Pages => ( is => 'rw', isa => 'HashRef', default => sub { {} } );

sub snarf {
   my ($self, $url) = @_;
warn $url;
   my $p = CI::Page->new( url => $url )->snarf;
   $self->Pages->{$url} = $p;

   for my $link ( @{ $p->local_links } ) {
      if ( ! defined $self->Pages->{$link->{url}} ) {
         $self->snarf( $link->{url} );
      }
   }

   return $self;
}
